#encoding: utf-8

class OrderItem < ActiveRecord::Base
  include  SoftDeleted
  
  attr_accessible *column_names
  
  belongs_to :order
  belongs_to :merchant,class_name: 'Mp::Merchant'
  belongs_to :package
  
  def price
    fmt_cur(read_attribute :price)
  end
  
  def total
    fmt_cur(read_attribute :total)
  end
  
  def as_json options={}
    {
      id: id,
      order_id: order_id,
      count: count,
      price: price,
      merchant_id: merchant_id,
      merchant_name: merchant.try(:mch_name),
      package_name: package.try(:name),
      package_id: package_id,
      total: total
    }
  end
end