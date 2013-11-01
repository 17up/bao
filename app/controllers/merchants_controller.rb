#encoding: utf-8

class MerchantsController < ApplicationController
  def index
    @merchants = Mp::Merchant.all.map{|x| [x.mch_id,x.mch_name]}
    render_json 0,"ok",@merchants
  end

  def show
    @merchant = Mp::Merchant.find(params[:id])
    @stores = @merchant.active_stores(params).as_json(:only => [:store_name,:store_id])
    render_json 0,"ok",@stores
  end

  def detail
    attach = Attachment.where(ref_id: @merchant.id,ref_clazz: 'merchant').order(created_at: :desc).first
    render_with_json data: {package: @merchant.package_info,info: @merchant, mid_attachment: attach.nil? ? false : attach.try(:atta_name)}
  end
  
  def download_mid_file
    attach = Attachment.where(ref_id: @merchant.id,ref_clazz: 'merchant').order(created_at: :desc).first
    if attach.nil?
      render text: '附件不存在'
    else
      file =  "#{Rails.root}/public/#{attach.file.url}"
      puts "file:#{file}"
      if File.exist?(file)
        send_file file,filename: attach.atta_name,type: attach.atta_type
      else
        render text: '附件丢失'
      end
    end
  end

  def list
    @merchants = Mp::Merchant.list_by_member current_member,params
    data = {
      merchants: @merchants.map{|item| item.as_list_json },
      pagination_str: render_to_string(:template => "shared/_pagination",:locals => {:collection => @merchants},:layout => false)
    }
    render_with_json data: data
  end

  def create
    @merchant = Mp::Merchant.save_merchant current_member,params

    if @merchant.succ?
      @store = @merchant.stores.first
      render_with_json data:{id: @merchant.id,tid: @store.try(:store_tid_html),mid: @store.try(:store_mid_html)}
    else
      render_with_json status: -1,msg: get_record_errors(@merchant)
    end
  end

  alias update create

  def bind_account
    @member = @merchant.bind_account current_member,params
    if @member.succ?
      render_with_json data:{id: @merchant.id}
    else
      render_with_json status: -1,msg: get_record_errors(@member)
    end
  end

  def bind_package
    @merchant.bind_package current_member,params
    render_merchant
  end

  def freeze_merchant
    @merchant.freeze!
    render_merchant
  end

  def restore_merchant
    @merchant.restore!
    render_merchant
  end
  
  def info
    @merchant = current_merchant
    @programs = @merchant.programs(params)
    rs = []
    @programs.includes(:plan,plan: [:target]).each{|p| rs << {created_at: p.created_at.try(:to_s,:simple),plan: p.plan_sms_count,name: p.program_name,used: p.send_count}}
    rs << {name: '合计',plan: rs.map{|item| item[:plan].to_i}.sum,used: rs.map{|item| item[:used].to_i}.sum}    
    render_with_json data: {buy: @merchant.buy_info(params),usage: {data: rs, pagination_str: render_to_string(:template => "shared/_pagination",:locals => {:collection => @programs},:layout => false)}}
  end
  
  def available_sms_count
    render_with_json data: {personal: current_merchant.count_personal,custome: current_merchant.count_custome}
  end

  def action_missing(meth, *args, &block)
    if meth.to_s =~ /^info_for_(.+)$/
      @merchant = current_merchant
      render_with_json data: @merchant.send("#{$1}_info".to_sym,params)
    else
      super
    end        
  end

  protected
  def render_merchant
    if @merchant.succ?
       render_with_json data: @merchant.as_list_json
    else
      render_with_json status: -1,msg: get_record_errors(@merchant)
    end
  end
  def init_params
    @id = params[:merchant_id]||params[:id]
    @merchant = Mp::Merchant.find  @id if @id.present?
  end
end