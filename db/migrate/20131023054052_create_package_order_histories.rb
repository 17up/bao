class CreatePackageOrderHistories < ActiveRecord::Migration
  def change
    create_table :package_order_histories do |t|
      t.references :program,index: true
      t.references :plan,index: true
      t.references :package_order, index: true
      t.references :order, index: true
      t.references :order_item, index: true
      t.references :merchant, index: true
      t.references :package, index: true
      t.integer :count
      t.string :name
      t.string :package_category
      t.integer :last_count
      t.integer :parent_id,index: true
      t.string :program_code,index: true
      t.string :status,index: true
      
      t.timestamp :deleted_at
      t.boolean :deleted,default: false
      t.timestamps
    end
  end
end
