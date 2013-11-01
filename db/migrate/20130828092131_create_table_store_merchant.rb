class CreateTableStoreMerchant < ActiveRecord::Migration
  def change
    create_table  :_store2merchant do |t|
      t.integer   :store_id
      t.integer   :merchant_id
    end
  end
end
