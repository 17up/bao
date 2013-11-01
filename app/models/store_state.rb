#encoding: utf-8

class StoreState < ActiveRecord::Base
  self.inheritance_column = "disabled"
  attr_accessible *column_names
end
