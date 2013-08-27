class CreateClickTrackingLogs < ActiveRecord::Migration
  def change
    create_table :click_tracking_logs do |t|
      t.integer :coupon_id
      t.string  :category
      t.integer :clicked_hour
      t.date 	:clicked_day
      t.string  :ip
      t.string	:original_url

      t.timestamps
    end

    add_index :click_tracking_logs,   :coupon_id
    add_index :click_tracking_logs, 	:clicked_hour
    add_index :click_tracking_logs, 	:category
    add_index :click_tracking_logs,  :clicked_day
  end
end
