class CreateStoreStates < ActiveRecord::Migration
  def change
    create_table :store_states do |t|
      t.references :store, index: true
      t.references :merchant, index: true
      t.string :type,length:16
      t.string :value,length: 12
      t.timestamp :begin_time
      t.timestamp :end_time
      t.integer :return_num,default: 0
      t.integer :new_num,default: 0

      t.timestamps
    end
  end
end