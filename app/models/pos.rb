#encoding: utf-8

class Pos < ActiveRecord::Base
  include SoftDeleted
  
  attr_accessible *column_names
  
  belongs_to :merchant,class_name: 'Mp::Merchant'
  belongs_to :store,class_name: 'Mp::Store'
  
end
