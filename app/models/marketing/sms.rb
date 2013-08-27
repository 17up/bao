# -*- coding: utf-8 -*-
module Marketing
  class Sms < Base

    class << self
      def _mock
        sms = Marketing::Sms.create(store_id: 67)
        categorys = [:reply_count,:clicked_count,:pushed_count,:tick_count,:tick_amount]
        (30.days.ago.to_date..Date.parse('2013-08-20')).each do |the_day|
          categorys.each do |category|
            Marketing::Indicator.create(_marketings_id: sms.id, category: category,the_day: the_day,num: 0)
          end
        end
      end
    end

    %w(reply_count clicked_count pushed_count tick_count tick_amount).each do |name|
      define_method(name) do |start_date, end_date|
       Marketing::Indicator.where(_marketings_id: id,category: __callee__).where(the_day: start_date..end_date).order("the_day asc").map(&:num)
      end
    end

    def attention(start_date, end_date)
      [reply_count(start_date, end_date),clicked_count(start_date, end_date)].transpose.map{ |x| x.reduce(&:+) }
    end

    def exposure(start_date, end_date)
      pushed_count(start_date,end_date)
    end

  end
end