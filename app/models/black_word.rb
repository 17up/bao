#coding: utf-8

class BlackWord < ActiveRecord::Base
  include SoftDeleted
  attr_accessible *column_names
  
  validates :name, presence: true, uniqueness: true
  
  class<<self
    def valid?(str)
      BlackWord.where(active: true).each do |w|
        begin
          return false,w.name  if str =~ /#{w.name}/
        rescue => e
          next
        end
      end
      
      return true,nil
    end
  end
end