# -*- coding: utf-8 -*-
class Operate::StoreBook < ActiveRecord::Base
  include AttrAccessible
  Ways = [:period,:daily]

  TransCode = {
    "S22" => "传统消费",
    "S10" => "传统授权/预授权",
    "S20" => "传统预授权完成",
    "S35" => "预授权完成通知",
    "S80" => "预授权完成（手工）",
    "S24" => "传统取现交易",
    "S54" => "预约消费",
    "S36" => "积分消费",
    "S13" => "分期付款消费",
    "S37" => "联盟积分消费"
  }

  class << self

    def tick_people_sum(store_id, start_date, end_date)
      where(the_day: start_date..end_date).
        where(store_id: store_id).
        count("distinct card_no")
    end

    def tick_dist(store_id, start_date, end_date)
      _dist = where(the_day: start_date..end_date).
        where(store_id: store_id).
        pluck(:trans_amount).sort
      amount_dist = _dist.delete_if{ |x| x <= 0 }
      dist = {}
      dist_name = {}
      cnt = amount_dist.count
      return dist,dist_name if cnt.zero?
      0.upto(9) do |time|
        dist[time] = 0
        dist_name[time] = ""
      end
      the_begin = (cnt * 0.05).floor
      the_end = (cnt * 0.95).floor
      amount_interval = amount_dist[the_begin..the_end]
      sec = (amount_interval[-1] - amount_interval[0]) / 8
      sec = 1 if sec < 1
      amount_dist.each do |item|
        idx = ((item - amount_interval[0]) / sec).floor + 1
        idx = 0 if item < amount_interval[0].round
        idx = 9 if idx > 9
        dist[idx] += 1
      end
      1.upto(8) do |time|
        dist_name[time] = "#{(amount_interval[0] + sec*(time - 1)).round} ~ #{(amount_interval[0] + sec*time).round}"
      end
      dist_name[0] = "#{amount_interval[0].round} 以下"
      dist_name[9] = "#{(amount_interval[0] + sec*8).round} 及以上"
      return dist,dist_name
    end

    def tick_freq(store_id, start_date, end_date)
      card_group = select("count(1) as cnt, card_no, round(sum(trans_amount),2) as amount").
        where(the_day: start_date..end_date).
        where(store_id: store_id).
        group(:card_no).
        map do |book|
          [book.card_no, book.cnt, book.amount]
        end
      freq = {}
      1.upto(10) do |time|
        if time < 10
          _freq = card_group.select { |v| v[1] == time }
        else
          _freq = card_group.select { |v| v[1] >= time }
        end
        cnt = _freq.count
        amount = _freq.reduce(0) {|memo, v| memo += v[2] }
        freq[time] = [cnt,amount.round(2)]
      end
      cnt_all = freq.sum { |k,v|  v[0] }
      amount_all = freq.sum { |k,v| v[1] }
      # amount_all
      freq.each do |k,v|
        cnt_per = (v[0] / cnt_all.to_f).round(2)
        amount_per = (v[1] / amount_all.to_f).round(2)
        per = k * v[0]
        customer_per = (v[1] / (per.zero? ? 1 : per)).round(2)
        freq[k] << cnt_per
        freq[k] << amount_per
        freq[k] << customer_per
      end
      freq
    end

    def tick_count(store_id, start_date, end_date, way)
      case way.to_sym
      when :period
        Hash[(0...24).map do | idx |
            [idx.to_s,0]
          end].merge(
        Hash[select("count(1) as cnt, the_hour").
          where(the_day: start_date..end_date).
          where(store_id: store_id).
          group(:the_hour).
          map do |book|
            [book.the_hour.to_s(:db), book.cnt]
          end])
      when :daily
        Hash[(start_date..end_date).map do | day |
            [day.to_s(:db),0]
          end].merge(
        Hash[select("count(1) as cnt, the_day").
          where(the_day: start_date..end_date).
          where(store_id: store_id).
          group(:the_day).
          map do |book|
            [book.the_day.to_s(:db), book.cnt]
          end])
      end
    end

    def tick_amount(store_id, start_date, end_date, way)
      case way.to_sym
      when :period
        Hash[(0...24).map do | idx |
            [idx.to_s,0]
          end].merge(
        Hash[select("round(sum(trans_amount),2) as cnt, the_hour").
          where(the_day: start_date..end_date).
          where(store_id: store_id).
          group(:the_hour).
          map do |book|
            [book.the_hour.to_s(:db), book.cnt.to_f.round(2)]
          end])
      when :daily
        Hash[(start_date..end_date).map do | day |
            [day.to_s(:db),0]
          end].merge(
        Hash[select("round(sum(trans_amount),2) as cnt, the_day").
          where(the_day: start_date..end_date).
          where(store_id: store_id).
          group(:the_day).
          map do |book|
            [book.the_day.to_s(:db), book.cnt.to_f.round(2)]
          end])
      end
    end

    def tick_people(store_id, start_date, end_date, way)
      case way.to_sym
      when :period
        Hash[(0...24).map do | idx |
            [idx.to_s,0]
          end].merge(
        Hash[select("count(distinct card_no) as cnt, the_hour").
          where(the_day: start_date..end_date).
          where(store_id: store_id).
          group(:the_hour).
          map do |book|
            [book.the_hour.to_s(:db), book.cnt]
          end])
      when :daily
        Hash[(start_date..end_date).map do | day |
            [day.to_s(:db),0]
          end].merge(
        Hash[select("count(distinct card_no) as cnt, the_day").
          where(the_day: start_date..end_date).
          where(store_id: store_id).
          group(:the_day).
          map do |book|
            [book.the_day.to_s(:db), book.cnt]
          end])
      end
      #
    end

    def tick_per(store_id, start_date, end_date, way)
      case way.to_sym
      when :period
        Hash[(0...24).map do | idx |
            [idx.to_s,0]
          end].merge(
        Hash[select("round(avg(trans_amount),2) as cnt, the_hour").
          where(the_day: start_date..end_date).
          where(store_id: store_id).
          group(:the_hour).
          map do |book|
            [book.the_hour.to_s(:db), book.cnt.to_f.round(2)]
          end])
      when :daily
        Hash[(start_date..end_date).map do | day |
            [day.to_s(:db),0]
          end].merge(
        Hash[select("round(avg(trans_amount),2) as cnt, the_day").
          where(the_day: start_date..end_date).
          where(store_id: store_id).
          group(:the_day).
          map do |book|
            [book.the_day.to_s(:db), book.cnt.to_f.round(2)]
          end])
      end
    end

    def __mock__
      100.times do
        _temp_dt = ((24*rand()).to_i).days.ago
        create( trans_rcv_ts: _temp_dt,
                store_id: (1000*rand()).to_i,
                the_day: _temp_dt.to_date,
                the_hour: (24*rand()).to_i,
                trans_amount: (100*rand()).to_i,
                tid: "889879018727218972#{(10*rand()).to_i}#{(10*rand()).to_i}",
                mid: "37878898790187272#{(10*rand()).to_i}#{(10*rand()).to_i}",
                card_no: "6223787889879018727218#{(10*rand()).to_i}#{(10*rand()).to_i}",
                trans_code: "727218#{(10*rand()).to_i}#{(10*rand()).to_i}"
              )
      end
    end
  end


  def as_json
    ext = {
      trans_rcv_ts: trans_rcv_ts.to_s(:db),
      card_no: card_no.to_s[-4..-1],
      trans_code: TransCode[trans_code] || "传统消费"
    }
    super(:only => [:trans_amount,:mid,:tid]).merge(ext)
  end
end
