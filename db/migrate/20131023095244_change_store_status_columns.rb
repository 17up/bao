class ChangeStoreStatusColumns < ActiveRecord::Migration
  def change
    remove_column :store_states,:return_num
    remove_column :store_states,:new_num
    
    add_column  :store_states,:count,:integer,default: 0
  end
end
