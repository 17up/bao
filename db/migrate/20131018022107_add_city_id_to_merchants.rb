class AddCityIdToMerchants < ActiveRecord::Migration
  def change
    add_column '_mch_info', :city_id, :integer,index: true
  end
end
