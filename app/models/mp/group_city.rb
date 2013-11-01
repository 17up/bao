#encoding: utf-8

class Mp::GroupCity < ActiveRecord::Base
  self.table_name =  "group_cities"
  attr_accessible *column_names
  
  scope :active_cities,->{where(active: 1)}
end
