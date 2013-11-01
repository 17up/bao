class AddAgentToMerchants < ActiveRecord::Migration
  def change
    add_column '_mch_info', :agent, :boolean,default: false,index: true
  end
end
