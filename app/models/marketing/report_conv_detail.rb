# -*- coding: utf-8 -*-
module Marketing
  class ReportConvDetail  <  ActiveRecord::Base
    self.table_name = "_report_conv_details"
    belongs_to :marketings,class_name: Marketing::Base, foreign_key: "_marketings_id"
    attr_accessible *column_names.reject{ |key,val| key.to_sym == :id }.map{ |key,val| key.to_sym}

    class << self
      def _mock
        100.times do
          create(trans_rcv_ts: Time.current,
                  trans_at: 100,
                  mid: "1111111111111",
                  tid: "pidxxxxxxxx",
                  mobile: 13688888888,
                  card: 622378788987901872721897,
                  program_name: "天鹅湖",
                  _marketings_id: 1,
                  succ_time: Time.current)
        end
      end
    end

    def format_mobile
      mobile.to_s[0..2] + "****" + mobile.to_s[7..10]
    end

    def format_card
      card.to_s[-4..-1]
    end

    def as_json
      ext = {
        trans_rcv_ts: trans_rcv_ts.to_s(:db),
        mobile: format_mobile,
        card: format_card,
        succ_time: succ_time.to_s(:db)
      }
      super(:only => [:trans_at,:mid,:tid,:program_name]).merge(ext)
    end

  end
end