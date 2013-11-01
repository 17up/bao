class RemoveFreezedFromMerchants < ActiveRecord::Migration
  def change
    remove_column '_mch_info', :freezed
  end
end
