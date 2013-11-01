class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :order, index: true
      t.references :merchant, index: true
      t.string :source,default: 'package'
      t.references :package, index: true
      t.decimal :price,precision: 10, scale: 2
      t.integer :count
      t.string :unit,length: 8
      t.decimal :total,precision: 10, scale: 2
      t.timestamp :deleted_at
      t.boolean :deleted,default: false
      t.timestamps
    end
    
    add_column :orders,:deleted_at,:timestamp
    add_column :orders,:deleted,:boolean,default: false
  end
end
