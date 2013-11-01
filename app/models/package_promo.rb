#coding: utf-8

class PackagePromo < ActiveRecord::Base
  belongs_to :package
  
  
  def price
    _price = read_attribute :price
    _price.to_f
  end
  
  def as_json config={}
    super(:only => [:id,:package_id,:name,:min,:max,:price])
  end
end
