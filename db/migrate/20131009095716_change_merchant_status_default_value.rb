class ChangeMerchantStatusDefaultValue < ActiveRecord::Migration
  def change
    change_column '_mch_info', :status, :string, default: 'pending'
  end
end
