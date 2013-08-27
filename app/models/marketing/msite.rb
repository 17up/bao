# -*- coding: utf-8 -*-
module Marketing
  class Msite < Base

    %w(page_views weibo_follows weixin_follows coupon_downloads cellphone_calls tick_count tick_amount).each do |name|
      define_method(name) do |start_date, end_date|
       Marketing::Indicator.where(_marketings_id: id,category: __callee__).where(the_day: start_date..end_date).order("the_day asc").map(&:num)
      end
    end

    def exposure(start_date, end_date)
      page_views(start_date, end_date)
    end

    def attention(start_date, end_date)
      [weibo_follows(start_date ,end_date),weixin_follows(start_date, end_date),
      cellphone_calls(start_date ,end_date),coupon_downloads(start_date ,end_date)].transpose.map{ |x| x.reduce(&:+) }
    end
  end
end