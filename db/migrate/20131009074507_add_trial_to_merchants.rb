class AddTrialToMerchants < ActiveRecord::Migration
  def change
    add_column '_mch_info', :trial, :boolean,default: false
  end
end
