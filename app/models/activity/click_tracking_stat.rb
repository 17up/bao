# -*- coding: utf-8 -*-

module Activity
  class ClickTrackingStat < Activity::Base
    attr_accessible *[:category, :coupon_id, :clicked_day, :total_count]

    class << self
      def build(category, coupon_id)
        clicked_day = Date.today.strftime("%Y-%m-%d")
        had_clicked = where(category: category,
                          coupon_id: coupon_id,
                          clicked_day:clicked_day).first

        if had_clicked
          had_clicked.total_count += 1
          had_clicked.save
        else
          create(category: category,
                 coupon_id: coupon_id,
                 clicked_day: clicked_day,
                 total_count: 1)
        end
      end
    end
  end 
end