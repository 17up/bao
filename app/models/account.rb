#encoding: utf-8

class Account < ActiveRecord::Base
  self.table_name = "members"
  
  def change_password config
    self.update_attributes password: config[:password]
  end
end