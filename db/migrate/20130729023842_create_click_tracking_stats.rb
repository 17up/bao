class CreateClickTrackingStats < ActiveRecord::Migration
  def change
    create_table :click_tracking_stats do |t|
      t.integer :coupon_id
      t.string  :category
      t.date 	:clicked_day
      t.integer :total_count
    end

    add_index :click_tracking_stats,  :coupon_id
    add_index :click_tracking_stats, 	:clicked_day
    add_index :click_tracking_stats,  :category
  end
end