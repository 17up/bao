class CreateTableReportConvDetails < ActiveRecord::Migration
  def change
    create_table :_report_conv_details do |t|
      t.string      :marketing_type
      t.string      :program_name
      t.string      :mid
      t.string      :tid
      t.string      :mobile
      t.string      :mobile_zone
      t.datetime    :push_time
      t.datetime    :succ_time
      t.integer     :push_type
      t.integer     :user_type
      t.string      :channel
      t.string      :service_id
      t.text        :sms_content
      t.string      :card
      t.string      :trans_id
      t.string      :mchnt_tp
      t.string      :acpt_ins_id_cd
      t.string      :iss_ins_id_c
      t.string      :cups_card_in
      t.string      :cups_sig_card_in
      t.string      :card_cata
      t.string      :card_class
      t.string      :card_attr 
      t.string      :card_prod
      t.string      :card_brand
      t.string      :card_lvl
      t.string      :trans_chnl
      t.string      :trans_media
      t.string      :trans_at
      t.datetime    :trans_rcv_ts


      t.references :_marketings
    end
    add_index :_report_conv_details,  :_marketings_id
  end
end
