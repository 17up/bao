require 'json'
class OperatesStore

  class << self

    def get(store_id, action_name, begin_date, end_date)
      _data = $redis.get generate_key(store_id, action_name, begin_date, end_date)
      if _data
        JSON.parse _data
        #MultiJson.decode _data
      end
    end

    def save(store_id, action_name, begin_date, end_date, data, ttl = 24*3600*365)
      _key = generate_key(store_id, action_name, begin_date, end_date)
      $redis.setex(_key, ttl, data.to_json)
      # $redis.setex(_key, ttl, MultiJson.encode(data))
    end

    private
    def generate_key(store_id, action_name, begin_date, end_date)
      "Operates:#{store_id}:#{action_name}:#{begin_date.to_s(:db)}:#{end_date.to_s(:db)}"
    end

  end
end
