class AddAddressToMerchants < ActiveRecord::Migration
  def change
    add_column '_mch_info', :address, :string
  end
end
