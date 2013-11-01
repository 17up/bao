#encoding: utf-8

class MerchantCategory < ActiveRecord::Base
  include SoftDeleted
  attr_accessible *column_names
    
  belongs_to :parent,class_name: 'MerchantCategory'
  
  def name_path
    if parent.present?
      "#{parent.try(:name)}/#{name}"
    else
      name
    end
  end
  
  def as_json config={}
    super(:only => [:id,:name,:parent_id])
  end
end