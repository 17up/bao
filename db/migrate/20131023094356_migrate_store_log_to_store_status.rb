class MigrateStoreLogToStoreStatus < ActiveRecord::Migration
  def change
    Mp::Store.where(status: 1).each do |store|
      puts "\tupdate store:#{store.store_name}"
      StoreState.create merchant_id: store.mch_id,store_id: store.store_id,type: 'new',value: 'done'
      StoreState.create merchant_id: store.mch_id,store_id: store.store_id,type: 'return',value: 'done'
    end
  end
end
