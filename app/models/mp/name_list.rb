#coding: utf-8
module Mp
  class NameList < ActiveRecord::Base
    belongs_to :user
    belongs_to :merchant
    belongs_to :store
    
    has_many :name_mobiles
    attr_accessible *column_names

    def as_json config={}
      ext = {
        created_at: created_at.strftime("%Y-%m-%d")
      }
      super(:only => [:id, :name, :count]).merge(ext)
    end
  end
end
