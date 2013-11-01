class ChangePriceLength < ActiveRecord::Migration
  def change
    change_column :orders,:price,:decimal,precision: 20, scale: 2
    change_column :order_items,:price,:decimal,precision: 20, scale: 2
    change_column :order_items,:total,:decimal,precision: 20, scale: 2
    change_column '_mch_info',:amount,:decimal,precision: 20, scale: 2
  end
end
