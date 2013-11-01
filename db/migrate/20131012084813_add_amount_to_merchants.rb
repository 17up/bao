class AddAmountToMerchants < ActiveRecord::Migration
  def change
    add_column '_mch_info', :amount, :decimal,precision: 10, scale: 2,default: 0    
  end
end
