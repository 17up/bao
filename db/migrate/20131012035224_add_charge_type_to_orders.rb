class AddChargeTypeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :charge_type, :string,length: 8
  end
end
