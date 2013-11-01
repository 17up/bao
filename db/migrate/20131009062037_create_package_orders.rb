class CreatePackageOrders < ActiveRecord::Migration
  def change
    create_table :package_orders do |t|
      t.references :order, index: true
      t.references :order_item, index: true
      t.references :merchant, index: true
      t.references :creator, index: true
      t.references :package, index: true
      t.integer :count
      t.references :package_promo, index: true
      t.string :name
      t.integer :used

      t.timestamps
    end
  end
end
