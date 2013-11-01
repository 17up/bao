class ChangeChargeTypeDefaultValue < ActiveRecord::Migration
  def change
    change_column :orders,:charge_type,:string,length: 8,default: 'merchant'
    execute "update orders set charge_type='merchant' where charge_type is null"
  end
end
