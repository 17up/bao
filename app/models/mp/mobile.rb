#coding: utf-8
module Mp
  class Mobile < ActiveRecord::Base
    self.table_name = "shanghai_mobiles"
    attr_accessible *column_names
  end
end