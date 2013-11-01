# -*- coding: utf-8 -*-
class Operate::CardProp < ActiveRecord::Base
  include AttrAccessible

  CardLevel = {
    0 => "普卡",
    1 => "银卡",
    2 => "金卡",
    3 => "白金卡",
    4 => "钻石卡",
    5 => "无限卡",
    6 => "其他"
  }

  class << self

    def gender_dist(store_id, start_date, end_date)
      gender = where(store_id: store_id, the_day: start_date..end_date).pluck(:gender)
      man = gender.count{|x| x <= 0.3}
      woman= gender.count{|x| x >= 0.7}
      total = man + woman
      return [0,0] if total.zero?
      man_dist = ((man / (total.zero? ? 1.0 : total.to_f)) * 100).round(2)
      [man_dist, (100 - man_dist).round(2)]
    end

    def card_level_dist(store_id, start_date, end_date)
      card_level = where(store_id: store_id, the_day: start_date..end_date).pluck(:card_level)
      cnt = card_level.count.to_f
      ret = Array.new
      Settings.level.each do |name, code|
        ret << [name ,((card_level.count{ |x| code.include?(x.to_i) } / cnt) * 100).round(2)]
      end
      ret
    end

    def customer_dist(store_id, start_date, end_date)
      customer = {}
      where(store_id: store_id, the_day: start_date..end_date).order("the_day DESC").pluck(:card_no,:is_new).each do |one|
        customer[one[0]] = one[1]
      end
      return customer.count{ |card_no,is_new| is_new }, customer.count{ |card_no,is_new| !is_new }
    end

    def get_tag_dist_by_code_arr(store_id, start_date, end_date)
      tags = where(store_id: store_id).where(the_day: start_date..end_date).pluck(:tags)
      _cnt = tags.count.to_f
      prop_dist = Array.new
      prop_name = Array.new
      tag_code_arr.each do |name, code|
        prop_name << name
        prop_dist << ((tags.count{ |x| x & code > 0 } / _cnt) * 100).round(2)
      end
      [prop_name, prop_dist]
    end

    def ability_dist(store_id, start_date, end_date)
      sort_dist = where(the_day: start_date..end_date).
        where(store_id: store_id).
        pluck(:ability).sort
      _dist = sort_dist.delete_if{ |x| x <= 0 }
      cnt = _dist.count
      return [] if cnt.zero?
      the_begin = (cnt * 0.1).floor
      the_end = (cnt * 0.9).floor
      _interval = _dist[the_begin..the_end]

      sec = ((_interval[-1] - _interval[0]) / 3)
      sec = 1 if sec < 1
      dist_cnt = {}
      dist_name = {}
      0.upto(4) do |time|
        dist_cnt[time] = 0
        dist_name[time] = ""
      end
      _dist.each do |item|
        idx = ((item - _interval[0]) / sec).floor + 1
        idx = 0 if item < _interval[0].round
        idx = 4 if idx > 4
        dist_cnt[idx] += 1
      end
      dist_name[0] = "#{_dist[the_begin].round} 以下"
      dist_name[4] = "#{(_dist[the_begin] + sec*3).round} 及以上"
      1.upto(3) do |time|
        dist_name[time] = "#{(_dist[the_begin] + sec*(time -1)).round} ~ #{(_dist[the_begin] + sec*time).round}"
      end
      ret = Array.new
      ret << dist_name.map{|key,val| val}
      ret << dist_cnt.map{ |key,val| val}
      ret
    end

    def intensity_dist(store_id, start_date, end_date)
      _dist = where(the_day: start_date..end_date).
        where(store_id: store_id).pluck(:intensity).sort
      ret = Array.new
      1.upto(10) do |time|
        if time == 10
          ret <<  _dist.count { |x| x >= 10 }
        else
          ret <<  _dist.count{ |x| x == time }
        end
      end
      ret
    end

    def __mock__
      1000.times do
        _temp_dt = ((24*rand()).to_i).days.ago
        create( store_id: (1000*rand()).to_i,
                the_day: _temp_dt.to_date,
                is_new: rand() > 0.5 ? true : false,
                ability: (10000*rand()).to_i,
                intensity: (5*rand()).to_i + 1,
                tags: (8192*rand()).to_i,
                gender: rand().round(2),
                card_no: "6223787889879018727218#{(10*rand()).to_i}#{(10*rand()).to_i}",
                card_level: (6*rand()).to_i)
      end
    end

    private

    def tag_code_arr
      tags_hash = Hash[Operate::Tag.limit(50).map do | t|
        [t.tag_name,t.tag_code]
      end]
      prop_code = Array.new
      Settings.tags.each do |name|
        prop_code << [name, tags_hash[name]]
      end
      prop_code
    end
  end

end
