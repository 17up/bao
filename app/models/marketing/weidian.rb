# -*- coding: utf-8 -*-
module Marketing
  class Weidian < Base

    class << self
      def _mock
        sms = Marketing::Weidian.create(store_id: 100, program_code: "Weidian")
        categorys = [:page_views,:follows,:tick_count,:tick_amount]
        (30.days.ago.to_date..DateTime.now.to_date).each do |the_day|
          categorys.each do |category|
            Marketing::Indicator.create(_marketings_id: sms.id, category: category,the_day: the_day,num: 50 + rand(50))
          end
        end
      end
    end

    %w(page_views follows tick_count tick_amount).each do |name|
      define_method(name) do |start_date, end_date|
       Marketing::Indicator.where(_marketings_id: id,category: __callee__).where(the_day: start_date..end_date).order("the_day asc").map(&:num)
      end
    end

    def attention(start_date, end_date)
      follows(start_date, end_date)
    end

    def exposure(start_date, end_date)
      page_views(start_date, end_date)
    end

  end
end