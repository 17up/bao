class AddCreatorToMerchant < ActiveRecord::Migration
  def change
    add_column '_mch_info', :creator_id, :integer
    add_column '_mch_info', :agent_id, :integer
  end
end