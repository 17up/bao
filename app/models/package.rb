#coding: utf-8

class Package < ActiveRecord::Base
  attr_accessible *column_names
  
  scope :basics,->{where(category: 'basic')} 
  scope :added, ->{where(category: 'added')} 
  
  def price
    (read_attribute :price).to_f
  end

  def promo_price c,calc_total=false
    c = c.to_i * 10000
    promos = PackagePromo.where(package_id: self.id)
    if promos.empty? 
      _price = price
    else
      promos = promos.where('min<=?',c)
      if promos.empty?
        _price = price
      else
        promo = promos.where('max>=?',c).order(max: :asc).first
        promo = promos.order(min: :desc).first if promo.nil?
        _price = promo.price.to_f
      end
    end
    
    fmt_cur(calc_total ? c.to_i * _price : _price)
  end
  
  def as_json config={}
    super(:only => [:id,:code,:name,:price])
  end
end