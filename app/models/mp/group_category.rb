#encoding: utf-8

class Mp::GroupCategory < ActiveRecord::Base
  self.table_name =  "group_categories"
  attr_accessible *column_names
  
  scope :mtcs, ->{where(parent_id: nil).order(order_index: :desc)}
end
