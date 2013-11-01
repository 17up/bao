class OperatesService
  class << self

    def check(store_id, start_date, end_date)
      had_card_props = Operate::CardProp.where(the_day: start_date..end_date).
          where(store_id: store_id).exists?
      had_store_books = Operate::StoreBook.where(the_day: start_date..end_date).
          where(store_id: store_id).exists?
      book = Operate::StoreBook.where(store_id: store_id).order("the_day desc").last
      current = 3.months.ago.to_date
      earliest = book && book.the_day.to_date || 1.months.ago.to_date

      {
          valid: (had_card_props && had_store_books).nil? ? false : true,
          begin_date: {
              current: [earliest, current].max.strftime('%Y-%m'),
              earliest: earliest.strftime('%Y-%m')
          }
      }
    end


    def latestoverview(store_id, start_date, end_date)
      new_customer, old_customer = Operate::CardProp.customer_dist(store_id, start_date, end_date)

      tick_amount_daily_hash = Operate::StoreBook.tick_amount(store_id, start_date, end_date, :daily)
      tick_count_daily_hash = Operate::StoreBook.tick_count(store_id, start_date, end_date, :daily)
      tick_per_daily_hash = Operate::StoreBook.tick_per(store_id, start_date, end_date, :daily)
      tick_people_daily_hash = Operate::StoreBook.tick_people(store_id, start_date, end_date, :daily)

      tick_amount_daily = tick_amount_daily_hash.map { |key, val| val }
      tick_count_daily = tick_count_daily_hash.map { |key, val| val }
      tick_per_daily = tick_per_daily_hash.map { |key, val| val }
      tick_people_daily = tick_people_daily_hash.map { |key, val| val }

      _amount = tick_amount_daily.sum.round(2)
      _count = tick_count_daily.sum
      _per = _count != 0 ? (tick_amount_daily.sum / _count.to_f).round(2) : 0

      {
          begin_date: start_date,
          end_date: end_date,
          summary: [_count, Operate::StoreBook.tick_people_sum(store_id, start_date, end_date), new_customer, old_customer, _amount, _per],
          daily: {
              tick_amount: tick_amount_daily,
              tick_count: tick_count_daily,
              tick_per: tick_per_daily,
              tick_people: tick_people_daily
          }
      }
    end

    def overview(store_id, start_date, end_date)
      new_customer, old_customer = Operate::CardProp.customer_dist(store_id, start_date, end_date)

      daily_statis = Array.new

      tick_amount_daily_hash = Operate::StoreBook.tick_amount(store_id, start_date, end_date, :daily)
      tick_count_daily_hash = Operate::StoreBook.tick_count(store_id, start_date, end_date, :daily)
      tick_per_daily_hash = Operate::StoreBook.tick_per(store_id, start_date, end_date, :daily)
      tick_people_daily_hash = Operate::StoreBook.tick_people(store_id, start_date, end_date, :daily)

      tick_amount_daily = tick_amount_daily_hash.map { |key, val| val }
      tick_count_daily = tick_count_daily_hash.map { |key, val| val }
      tick_per_daily = tick_per_daily_hash.map { |key, val| val }
      tick_people_daily = tick_people_daily_hash.map { |key, val| val }

      (start_date..end_date).each do |the_day|
        day = the_day.to_s(:db)
        daily_statis << [day, tick_count_daily_hash[day], tick_people_daily_hash[day], tick_amount_daily_hash[day], tick_per_daily_hash[day]]
      end

      period_statis = Array.new

      tick_amount_period_hash = Operate::StoreBook.tick_amount(store_id, start_date, end_date, :period)
      tick_count_period_hash = Operate::StoreBook.tick_count(store_id, start_date, end_date, :period)
      tick_per_period_hash = Operate::StoreBook.tick_per(store_id, start_date, end_date, :period)
      tick_people_period_hash = Operate::StoreBook.tick_people(store_id, start_date, end_date, :period)

      tick_amount_period = tick_amount_period_hash.map { |key, val| val }
      tick_count_period = tick_count_period_hash.map { |key, val| val }
      tick_per_period = tick_per_period_hash.map { |key, val| val }
      tick_people_period = tick_people_period_hash.map { |key, val| val }

      (0..23).each do |period|
        period_name = "%s:00-%s:59" % [period, period]
        period_statis << [period_name, tick_count_period[period], tick_people_period[period], tick_amount_period[period], tick_per_period[period]]
      end
      _amount = tick_amount_daily.sum.round(2)
      _count = tick_count_daily.sum
      _per = _count != 0 ? (tick_amount_daily.sum / _count.to_f).round(2) : 0

      {
          begin_date: start_date,
          end_date: end_date,
          summary: [_count, Operate::StoreBook.tick_people_sum(store_id, start_date, end_date), new_customer, old_customer, _amount, _per],
          daily: {
              tick_amount: tick_amount_daily,
              tick_count: tick_count_daily,
              tick_per: tick_per_daily,
              tick_people: tick_people_daily,
              statis: daily_statis
          },
          period: {
              tick_amount: tick_amount_period,
              tick_count: tick_count_period,
              tick_per: tick_per_period,
              tick_people: tick_people_period,
              statis: period_statis
          }
      }
    end


    def dealrecord(store_id, start_date, end_date)
      tick_dist_data, tick_dist_name = Operate::StoreBook.tick_dist(store_id, start_date, end_date)
      tick_freq_hash = Operate::StoreBook.tick_freq(store_id, start_date, end_date)
      tick_freq = tick_freq_hash.map { |key, val| val }

      {
          begin_date: start_date,
          end_date: end_date,
          tick_dist: {
              data: tick_dist_data.map { |key, val| val },
              name: tick_dist_name.map { |key, val| val }
          },
          tick_freq: tick_freq
      }
    end

    def feature(store_id, start_date, end_date)
      ability_dist = Operate::CardProp.ability_dist(store_id, start_date, end_date)
      gender_dist = Operate::CardProp.gender_dist(store_id, start_date, end_date)
      intensity_dist = Operate::CardProp.intensity_dist(store_id, start_date, end_date)
      tag_dist = Operate::CardProp.get_tag_dist_by_code_arr(store_id, start_date, end_date)
      level_dist = Operate::CardProp.card_level_dist(store_id, start_date, end_date)

      {
          begin_date: start_date,
          end_date: end_date,
          gender_dist: gender_dist,
          ability_dist: ability_dist,
          intensity_dist: intensity_dist,
          tag_dist: tag_dist,
          level_dist: level_dist
      }
    end

  end
end
