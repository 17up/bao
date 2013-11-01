class AddFreezedToMerchants < ActiveRecord::Migration
  def change
    add_column '_mch_info', :freezed, :boolean,default: false
  end
end
