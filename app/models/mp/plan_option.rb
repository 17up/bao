#coding: utf-8
module Mp
  class PlanOption
    class<<self
      def list
        json = []

        CATEGORIES.each do |c|
          key = c[:key]
          key = $1 if key =~ /(.*)\[\]/
          items = []

          ITEMS[key.to_sym].each do |item|
            items << {key: "#{key.to_s}_#{PinYin.abbr item}", name: item}
          end

          json << c.merge({items: items})
        end

        json
      end

      def calc_score config={}
        debug_msg = []
        total_score = 0
        total_score += 9 if config[:preference].nil? || config[:preference].empty?
        debug_msg<< "9,preference is null" if config[:preference].nil? || config[:preference].empty?

        config.sort_by.each do |key, value|
          key = $1 if key =~ /(.*)\[\]/

          if ITEMS.keys.include?(key.to_sym)
            if value.is_a?(Array)
              value.each do |v|
                total_score+= VALUES[v.to_sym]||1
                debug_msg << "#{VALUES[v.to_sym]||1},#{v}"
              end
            else
              total_score+= VALUES[value.to_sym]||1
              debug_msg << "#{VALUES[value.to_sym]||1},#{value}"
            end
          else
            debug_msg << "0,invalid key:#{key}"
          end
        end

        puts debug_msg.join("\n")
        total_score

      end

      def calc_member_count config={}
        c = calc_score config
        case c
          when 9..12
            20
          when 13..18
            30
          when 19..24
            40
          when 24..29
            50
          when 30..34
            60
          else
            60
        end
      end

      CATEGORIES = [
          {key: 'sex', name: '消费性别', desc: '', multi: false},
          {key: 'age', name: '消费年龄', desc: '', multi: false},
          {key: 'preference[]', name: '消费偏好', desc: '', multi: true},
          {key: 'time', name: '统计时间', desc: '', multi: false},
          {key: 'frequency', name: '月均消费频次', desc: '', multi: false},
          {key: 'price', name: '月均消费金额', desc: '', multi: false},
          {key: 'night', name: '有夜消费习惯', desc: '', multi: false},
          {key: 'card_type', name: '持卡类型', desc: '', multi: false},
          {key: 'member', name: '老客户选择', desc: '', multi: false}
      ]

      ITEMS =
          {
              sex: %w{不限 男性 女性}, #2 1 1
              age: %w{不限 25岁以下 25-35岁 35-45岁 45岁以上}, # 4 1 1 1 1
              preference: %w{餐饮美食 购物百货 休闲娱乐 美容护体 旅游出行 酒店住宿 家具建材 汽车服务 结婚服务}, #1
              time: %w{不限 最近6个月 最近3个月 最近1个月}, #4 3 2 1
              frequency: %w{1次以上 2次以上 3次以上}, #3 2 1
              price: %w{不限 1000以上 5000元以上 10000元以上 20000元以上}, # 5 4 3 2 1
              night: %w{无 有}, # 2 1
              card_type: %w{普卡及以上 金卡及以上 白金卡/钻石卡}, # 3 2 1
              member: %w{不限 优先推送全部老客户 优先推送流失老客户} # 2 1 1
          }


      VALUES = {
          sex_bx: 2,

          age_bx: 4,

          time_bx: 4,
          time_zj6gy: 3,
          time_zj3gy: 2,

          frequency_1cys: 3,
          frequency_2cys: 2,

          price_bx: 5,
          price_1000ys: 4,
          price_5000yys: 3,
          price_10000yys: 2,

          night_w: 2,

          card_type_pkjys: 3,
          card_type_jkjys: 2,

          member_bx: 2
      }

      #个性化 5万
      #自定义名单 4千
    end
  end
end