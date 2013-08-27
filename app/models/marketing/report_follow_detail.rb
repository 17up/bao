# -*- coding: utf-8 -*-
module Marketing
  class ReportFollowDetail  <  ActiveRecord::Base
    self.table_name = "_report_follow_details"
    belongs_to :marketings,class_name: Marketing::Base, foreign_key: "_marketings_id"
    attr_accessible *column_names.reject{ |key,val| key.to_sym == :id }.map{ |key,val| key.to_sym}

    class << self
      def _mock
        100.times do
          create( mobile: 13688888888,
                  program_name: "银联微点夏季推荐",
                  care_type: "sms",
                  _marketings_id: 1,
                  care_time: Time.current)
        end
      end
    end

    def format_mobile
      #mobile.to_s[0..2] + "****" + mobile.to_s[7..10]
      "*******" + mobile.to_s[7..10]
    end

    def as_json
      {
        mobile: format_mobile,
        program_name: program_name,
        care_type: care_type,
        care_time: care_time.to_s(:db)
      }
    end

  end
end