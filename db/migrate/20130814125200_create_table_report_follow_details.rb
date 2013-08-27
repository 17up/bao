class CreateTableReportFollowDetails < ActiveRecord::Migration
  def change
    create_table :_report_follow_details do |t|
      t.string      :marketing_type
      t.string      :program_name
      t.string      :mobile
      t.string      :mobile_zone
      t.string      :care_type
      t.datetime    :care_time

      t.references  :_marketings
    end
    add_index :_report_follow_details,  :_marketings_id
  end
end
