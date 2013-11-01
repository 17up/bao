#coding: utf-8

class City < ActiveRecord::Base
  self.table_name = "_city_info"
  attr_accessible *column_names
  
  scope :provinces,->{where(city_class: 1)}
	scope :active,   -> {where(status: 1)}
  
  
  def parent_id
    case city_class
    when 1
      self.id if municipality?
    when 2
      self.up_province
    when 3
      self.up_city
    end
  end
  
  class<<self
    def select_city config={}
      city_id = config[:city_id]||config[:id]
      label = config[:label]||'province'
      
      if city_id.present?
        @city = City.find city_id
        @cities = []
    
        if @city.municipality? && label == 'province'
          @cities << @city
        else
          @cities = City.where("up_#{label}=?",@city.id)
          @cities = @cities.where(status: 1) if label=='province'
        end
      
        @cities
      else
        provinces
      end
    end
  end
  
  def as_json config={}
    {id: id,name: city_ch_name,city_name: city_name}
  end
end
