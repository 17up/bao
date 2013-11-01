class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.references :merchant, index: true
      t.string :order_code
      t.timestamp :audited_at
      t.references :auditor_id, index: true
      t.string :status,default: 'pending'
      t.decimal :price,precision: 10, scale: 2
      t.integer :count
      t.string :remark
      t.string :category_name,default: 'agent'

      t.timestamps
    end
  end
end
