class AddPackageTypeToMerchants < ActiveRecord::Migration
  def change
    add_column '_mch_info', :package_type, :string
    add_column '_mch_info', :package_id,   :integer
  end
end