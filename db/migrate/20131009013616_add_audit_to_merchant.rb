class AddAuditToMerchant < ActiveRecord::Migration
  def change
    add_column '_mch_info', :audit_status, :string,default: 'Pending',length: 8
    add_column '_mch_info', :auditor_id, :integer
    add_column '_mch_info', :audited_at, :timestamp
    
    add_index '_mch_info',:audit_status
    add_index '_mch_info',:auditor_id
    
  end
end