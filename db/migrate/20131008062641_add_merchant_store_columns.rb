class AddMerchantStoreColumns < ActiveRecord::Migration
  def change
    add_column '_mch_info',:company_name,:string
    add_column '_mch_info',:category_id,:integer
    add_column '_mch_info',:user_id,:integer
    add_column '_mch_info',:category_name,:string,default: 'upsmart'
    add_column '_mch_info',:created_at,:timestamp
    add_column '_mch_info',:updated_at,:timestamp
    
    change_column '_mch_info',:mch_name,:string,length: 64
    change_column '_mch_info',:mch_app_label,:string
    change_column '_mch_info',:mch_app_logo,:string
    change_column '_mch_info',:mch_phone,:string,length: 128
    
    add_column '_store_info',:city_id,:integer
    add_column '_store_info',:user_id,:integer
    
    change_column '_store_info',:store_name,:string
    change_column '_store_info',:store_address,:string
    change_column '_store_info',:store_phone,:string
    change_column '_store_info',:store_label,:string
    change_column '_store_info',:store_time,:string
    change_column '_store_info',:store_air,:string
    change_column '_store_info',:store_feature,:string
    change_column '_store_info',:search_name,:string
    change_column '_store_info',:trigger_count,:string
    change_column '_store_info',:price_stat,:string
    change_column '_store_info',:search_name,:string
  end
end
