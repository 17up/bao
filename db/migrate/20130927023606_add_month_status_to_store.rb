class AddMonthStatusToStore < ActiveRecord::Migration
  def change
    add_column '_store_info', :month_status, :integer,default: 0
  end
end
