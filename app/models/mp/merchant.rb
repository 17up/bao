#encoding: utf-8

class Mp::Merchant < ActiveRecord::Base
  self.table_name = '_mch_info'
  self.primary_key = 'mch_id'

  # include SoftDeleted
  include ArConstants
  include AuditAble
  include ZhbCategory

  attr_accessible *column_names

  default_scope {where("_mch_info.deleted_at is null and _mch_info.agent=0")}
  # default_scope {where("_mch_info.deleted_at is null and _mch_info.agent=0")}

  validates :mch_name, presence: true
  validates :mch_name, uniqueness: true
  has_many :stores, class_name: "Mp::Store", foreign_key: "mch_id"
  # has_many :active_stores, -> { where status: 1 }, class_name: "Mp::Store", foreign_key: "mch_id"
  has_one :mlog, class_name: "Mp::Mlog", foreign_key: "search_id"
  has_one :first_account,->{order('id asc').limit(1)}, class_name: "Mp::Member", foreign_key: "merchant_id"
  belongs_to :package
  has_many :package_orders
  belongs_to :category,class_name: 'MerchantCategory'
  has_many :package_orders


  def name
    mch_name
  end

  def active_stores config={}
    _type = config[:type].singularize
    if %w{return new}.include?(_type)
      Mp::Store.find StoreState.where(merchant_id: self.id,type: _type,value: 'done').collect(&:store_id)
    else
      stores
    end
  end

  def count name ,program = nil
    _count = package_orders.where(name: name).select('count - used count').collect(&:count).sum

    unless program.nil?
      program_count = PackageOrderHistory.where(program_id: program.id,parent_id: nil).order(created_at: :desc).first.try :count
      _count = _count + program_count.to_i if program_count.to_i>0
    end

    _count
  end

  def count_custome program=nil
    count 'custom',program
  end

  def count_personal program=nil
    count 'personal',program
  end

  def bind_account member,config={}
    reset_account

    Mp::Member.create category_name: 'merchant',store_id: get_store_id,merchant_id: self.id,
                      user_name: config[:mch_account],password: config[:password],creator_id: member.try(:id)
  end

  def bind_package member,config={}
    package_id = config[:package_id]
    self.package_id = config[:package_id]
    if self.save
      v = package.value
      self.update_attributes trial: true if package.code == '1001'
      if v.present?
        v.split(',').each do |item|
          k,v = item.split(':')
          PackageOrder.create merchant_id: mch_id,creator_id: member.id,package_id: package.id,name: k,count: v,used: 0,package_category: 'basic'
        end
      end
    end

    self
  end

  def reset_account
    Mp::Member.where(merchant_id: self.id).delete_all
  end

  def get_store_id
    Mp::Store.where(mch_id: self.id).first.id
  end


  def amount
    fmt_cur(read_attribute :amount)
  end

  def package_info config={}
    infos = []
    unless package.nil?
      # if merchant.trial?
        #todo:
      # end
        pas = package_orders.where(package_category: 'basic')

        pas.each_with_index do |p,index|
          infos << {type: p.name,name: index==0 ? "#{package.name}"  : '',desc: p.desc,count: p.count,used: p.used,remain: p.count.to_i - p.used.to_i ,times: index==0 ? duration  : '' }
        end

        infos << {type: 'app',name: pas.empty? ? package.name : '',desc: '银联微点推荐',count: '已发布'}
        infos << {type: 'month',name: '',desc: '月度经营分析报告',count: '已发布'}

        package_orders.where(package_category: 'added').each_with_index do |p,index|
          next if p.nil? || p.package.nil?
          infos << {type: p.name,name: index==0 ? '短信增值包' : '',desc: "#{p.package.name}",count: p.count,used: p.used,remain: p.count.to_i - p.used.to_i}
        end
      # end
    end

    infos
  end

  def buy_info config={}
    rs = []

    _type = config[:type]
    if %w{personal custom}.include?(_type)
       package_orders.where(name: _type).includes(:package).each do |p|
         rs << {created_at: p.created_at.try(:to_s,:simple),count: p.count,type: "#{p.package_category == 'basic' ? '' : '短信增值包-'}#{p.package.name}"}
       end
    end


    rs << {created_at: '合计',count: rs.map{|item| item[:count].to_i}.sum }

    rs
  end

  def programs config={}
    programs = Nexus::Program.where(
          plan_info_id: Nexus::PlanInfo.where(store_id: stores.collect(&:id)).select('id').collect(&:id)
    ).order('created_at desc').page(config[:page]||1)

  end

  def usage_info config={}
    rs = []
    programs(config).each do  |p|
      rs << {created_at: p.created_at.try(:to_s,:simple),plan: p.plan_count,name: p.program_name,used: p.send_count}
    end

    rs << {name: '合计',plan: rs.map{|item| item[:plan].to_i}.sum,used: rs.map{|item| item[:used].to_i}.sum}

    rs
  end

  def duration
    if approved?

      package_end.blank? ? "" : "#{package_begin.try :to_s,:date}至#{package_end.try :to_s,:date}"
    else
      status_name
    end
  end

  class<<self
    def save_merchant member,config={}
      @merchant = nil
      @id = config[:id]
      @merchant = Mp::Merchant.find_by(mch_id: @id) if @id.present?

      merchant_config = {mch_name: config[:mch_name],category_id: config[:category_id],mch_info: config[:mch_info],
                    mch_phone: config[:tel],company_name: config[:company_name],creator_id: member.try(:id),
                    category_name: member.try(:category_name),agent_id: member.try(:merchant_id),city_id: config[:city_id]}

      if @merchant.nil?
        @merchant = Mp::Merchant.create merchant_config
      else
        @merchant.update_attributes merchant_config
      end

      @id = @merchant.id

      if @merchant.succ?
        store_config = {mch_id: @merchant.id,store_name: @merchant.name,store_address: config[:address],city_id: config[:city_id],
                        store_city: config[:city_id],store_mid: config[:mid],store_tid: config[:tid],
                        store_info: @merchant.mch_info,store_phone: @merchant.mch_phone}

        @store = Mp::Store.find_by(mch_id: @id)
        if @store.nil?
          @store = Mp::Store.create store_config
        else
          @store.update_attributes store_config
        end

        attachment = Attachment.create_file config.merge({store_id: @store.id,ref_id: @merchant.id}), member
        unless attachment.id.blank?
          Pos.where(merchant_id: @id).delete_all

          mid,tid = save_mid_and_tid attachment
          @store.update_attributes store_mid: mid,store_tid: tid
        end
      end
      @merchant
    end

    def save_mid_and_tid attachment
      mids = []
      tids = []
      file_name = attachment.attach_file_path
      p file_name

      @lines = IO.readlines(file_name)

      @lines.each do |line|
        next if line.blank?

        ids = trim(line,false).gsub(' ', ';').gsub('_',';').gsub('-',';').gsub(':', ';').gsub(',', ';').split(';')

        ids.compact!
        ids = ids.select{|l| l.length>0}
        next if ids.empty?

        mid = ids.shift
        next if mid.blank?

        mids << mid

        if ids.empty?
          Pos.create merchant_id: @merchant.id,store_id: @store.id,mid: mid
        else
          (ids||[]).each do |tid|
            tids << tid if tid.present?
            Pos.create merchant_id: @merchant.id,store_id: @store.id,mid: mid,tid: tid
          end
        end
      end

      mids.compact!
      tids.compact!

      return mids.join('_'),tids.join('_')
    end

    def reset_merchant
      Mp::Store.where(mch_id: @id).delete_all
      Mp::Merchant.where(mch_id: @id).delete_all
    end

    def list_by_member member,config
      page = config[:page]||1
      merchant = Mp::Merchant.order(created_at: :desc)
      merchant = merchant.where('mch_name like ?',"%#{config[:mch_name]}%") if config[:mch_name].present?

      if member.agent?
        merchant = merchant.where(agent_id: member.merchant_id)
      elsif member.merchant?
        merchant = merchant.where(id: member.merchant_id)
      end

      merchant.includes(:package,:first_account,:category,category: [:parent]).page(page).per(10)
    end
  end

  def package_status
    if pending?
      '待开通'
    elsif reject?
      '审核不通过'
    else
      '有效套餐'
    end
  end

  #=====================================
  def as_list_json config={}
    account_name = first_account.try(:user_name)

    {
      id:id,
      name: mch_name,
      account_name: account_name,
      freezed: freeze_status,
      package_name: package.try(:name),
      status: status_name,
      editable: pending?,
      package_status: package_status,
      package_times: duration
    }
  end

  def as_json config={}
    _store = stores.first
    _city = _store.try(:city)
    {
      id: id,
      mch_name: mch_name,
      name: mch_name,
      editable: pending?,
      account_name: first_account.try(:user_name),
      account_id: first_account.try(:id),
      city_id: _city.try(:id),
      city_name: _city.try(:city_ch_name),
      parent_city_id: _city.try(:parent_id),
      parent_category_id: category.try(:parent_id),
      category_id: category.try(:id),
      category_name: category.try(:name_path),
      mch_info: mch_info,
      company_name: company_name,
      mid: _store.try(:store_mid_html),
      tid: _store.try(:store_tid_html),
      address: _store.try(:store_address),
      tel: _store.try(:store_phone)
    }
  end
end
