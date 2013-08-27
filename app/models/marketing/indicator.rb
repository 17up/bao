# -*- coding: utf-8 -*-
class Marketing::Indicator <  ActiveRecord::Base
  self.table_name = "_indicators"
  attr_accessible :category, :the_day, :marketing_id,:num
  belongs_to  :marketings ,class_name: Marketing::Base, foreign_key: "_marketings_id"

  attr_accessible *column_names.reject{ |key,val| key.to_sym == :id }.map{ |key,val| key.to_sym}
end
