#coding: utf-8
module Mp
  class Mobile < ActiveRecord::Base
    self.table_name = "shanghai_mobiles"

    #class<<self
    #  def update_table_name city
    #    Mp::Mobile.connect("#{city}_mobiles")
    #  end
    #end
  end
end