#coding: utf-8

class PackageOrder < ActiveRecord::Base
  include ArConstants
  # belongs_to :order
  # belongs_to :order_item
  belongs_to :merchant
  belongs_to :creator
  belongs_to :package
  belongs_to :package_promo
  
  attr_accessible *column_names
  
  def remain
    count - used
  end
  
  def desc
    PLAN_CATEGORIES[name.to_sym]
  end
end
