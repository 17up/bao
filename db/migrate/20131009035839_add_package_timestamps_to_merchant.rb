class AddPackageTimestampsToMerchant < ActiveRecord::Migration
  def change
    add_column '_mch_info', :package_begin, :timestamp
    add_column '_mch_info', :package_end, :timestamp
    
    rename_column '_mch_info',:audit_status,:status
  end
end
