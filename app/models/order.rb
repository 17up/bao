#encoding: utf-8

class Order < ActiveRecord::Base
  include  ZhbCategory
  include  SoftDeleted

  attr_accessible *column_names

  belongs_to :user,class_name: 'Mp::Member'
  belongs_to :merchant,class_name: 'Mp::Merchant'
  has_many   :order_items
  # belongs_to :auditor,class_name: 'Admin'

  # after_save :update_order_code
  #
  # def update_order_code
  #   @order.update_attributes order_code: gen_order_code(@order) if order_code.blank?
  # end

  class<<self
    def search member,config={}
      order = Order.where(merchant_id: member.merchant_id)
      order = order.where('charge_type=?',config[:charge_type]) if config[:charge_type].present?
      order = order.where('status=?',config[:status].downcase) if config[:status].present?
      order = order.where('created_at>=?',"#{config[:begin_at]} 00:00:00") if config[:begin_at].present?
      order = order.where('created_at<=?',"#{config[:end_at]} 23:59:59") if config[:end_at].present?
      order.page(config[:page]||1).per(10)
    end

    def charge_for_self member,config={}
      price = config[:price]||config[:number]
      if price.to_i > 0
        @order = Order.create user_id: member.id,merchant_id: member.merchant_id,category_name: member.category_name,
                           charge_type: 'self',count: 1,price: price

        @order.update_attributes order_code: Order.gen_order_code(@order) if @order.succ?
        @order
      else
        #nop
      end
    end

    def charge_for_merchant member,config={}
      @order = Order.new user_id: member.id,merchant_id: member.merchant_id,category_name: member.category_name,charge_type: 'merchant'
      total_count = 0
      total_price = 0

      package_ids = config[:package_id]
      counts = config[:count]

      if @order.save
        (config[:merchant_id]||[]).each_with_index do |m,i|
          package_id = package_ids[i]
          package = Package.find package_id
          count = counts[i].to_i
          count = count
          price = package.promo_price(count).to_f

          _total_price = price * count * 10000

          total_count += count
          puts "total_price:#{total_price},#{_total_price}"
          total_price += _total_price
          puts "\t#{total_price}"

          @order.order_items.create merchant_id: m,package_id: package_id,price: price ,count: count,total: _total_price
        end

        @order.update_attributes count: total_count,price: total_price,order_code: gen_order_code(@order)
      end
      @order
    end

    def gen_order_code order
      "#{order.category_integer}#{Time.now.strftime '%m%d%H%M%S'}#{order.id.to_s.rjust 5,'0'}#{rand(100)}"
    end
  end


  # alias charge_for_merchant charge

  def price
    fmt_cur read_attribute(:price)
  end

  def income?
    charge_type == 'self'
  end

  def expenses?
    charge_type == 'merchant'
  end

  def as_json_for_show config={}
    as_json(only:  [:id,:order_code, :count,:price]).merge(order_items: order_items)
  end

  def as_json config={}
    {
      order_code: order_code,
      created_at: created_at.to_s(:simple),
      income: income? ? price : '',
      expenses: expenses? ? price : '',
      remark: income? ? '为本账户充值'  : '为商户充值',
      status: ORDER_STATUS[status.to_sym],
      id: id,
      count: count,
      price: price
    }
  end
end