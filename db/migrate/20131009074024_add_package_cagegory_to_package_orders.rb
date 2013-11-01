class AddPackageCagegoryToPackageOrders < ActiveRecord::Migration
  def change
    add_column :package_orders, :package_category, :string
  end
end
