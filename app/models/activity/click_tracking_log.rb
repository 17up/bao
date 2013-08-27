# -*- coding: utf-8 -*-

module Activity
  class ClickTrackingLog < Activity::Base
    attr_accessible *[:category, :coupon_id, :clicked_hour, :ip, :original_url, :clicked_day]

    CATE = %w{cellphone reservation weixin weibo download view phonecall}

    class << self
      def by_category_and_date(cp_id,cate,begin_date,end_date)
        self.where(coupon_id: cp_id.to_i,category: cate).where(["clicked_day > ? AND clicked_day < ?",begin_date,end_date])
      end

      def group_by_day(cp_id,cate,begin_date,end_date)
        self.by_category_and_date(cp_id,cate,begin_date,end_date).group("clicked_day").count
      end

      # 24小时统计
      def count_group_by(cp_id,cate,begin_date,end_date)
        list = (0..23).to_a.inject({}){|a,x| a.merge({x =>  0})}
        data = self.by_category_and_date(cp_id,cate,begin_date,end_date).group("clicked_hour").count
        list.merge(data)
      end

      def build(category, coupon_id, ip, original_url)
        create( category: category,
              coupon_id: coupon_id,
                  ip: ip,
                  original_url: original_url,
                  clicked_day: Date.today,
              clicked_hour: DateTime.now.strftime("%H"))
      end

      def mock
        category = 
          [:website,:cellphone,:phonecall,:download,:weibo,:weixin,:reservation]
              (30.day.ago.to_date...Date.current).each do |day|
                   create(category: category[rand(6)],
                          coupon_id: 1,
                          clicked_day: day,
                          clicked_hour: 0.step(23,1).to_a.sample)
          end
      end
    end
  end
end