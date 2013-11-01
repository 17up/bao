#encoding: utf-8

class Mp::Customer < ActiveRecord::Base
  self.table_name =  "shanghai_54_return_customer"

  class<<self
    def connect(_table_name)
     self.table_name = _table_name #if table = ActiveRecord::Base.connection.tables.grep(/#{key}/)[0]
    end
    
    def count_by config
      store_id = config[:store_id]
      store = Mp::Store.find store_id
      self.connect "#{store.search_name}_#{store.search_id}_#{config[:label]}_customer"
      self.count
    end
  end
end
