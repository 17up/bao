#encoding: utf-8
require 'fileutils'

class GroupProperty
  include Mongoid::Document
  store_in database: "secondary"
  store_in collection: 'group_properties_shanghai'

  field :mobile, type: String
  field :zone, type: String
  field :count_month, type: Integer
  field :gain_month, type: Integer
  field :work_lat, type: Float
  field :work_lon, type: Float
  field :work_r, type: Float
  field :life_lat, type: Float
  field :life_lon, type: Float
  field :life_r, type: Float
  field :count_night, type: Float
  field :gain_night, type: Float
  field :sex, type: Float
  field :labels, type: Array
  field :stat_consume_all, type: Integer
  field :stat_consume_1000, type: Integer
  field :stat_consume_5000, type: Integer
  field :stat_consume_10000, type: Integer
  field :stat_consume_50000, type: Integer
  field :stat_consume_100000, type: Integer

  validates :mobile, :presence => true, :uniqueness => true

  class << self
    def store_in_collection(area)
      store_in collection: "group_properties_#{area}"
    end

    def options
      @cities = Mp::GroupCity.active_cities
      @categories = Mp::GroupCategory.mtcs

      _options = []
      _options << {multi:false, key: 'city',name: '推送城市',desc: '',items: @cities.map{|city| {key: "city_#{city.code}",name: city.name}} }
      _options << {multi:false, key: 'sex',name: '消费性别',desc: '',items: [{key: 'sex_bx',name: '不限'},{key: 'sex_0',name: '男'},{key: 'sex_1',name: '女'}] }
      _options << {multi:true, key: 'category[]',name: '消费偏好',desc: '',items: @categories.map{|category| {key: "category_#{category.mtc_id}",name: category.name}}  }
      _options << {multi:false, key: 'consume',name: '月均消费金额',desc: '',items: [{key: 'consume_bx',name: '不限'},{key: 'consume_1000',name: '1000以上'},{key: 'consume_5000',name: '5000以上'},{key: 'consume_10000',name: '10000以上'},{key: 'consume_20000',name: '20000以上'}] }
      _options << {multi:false, key: 'count',name: '月均消费频次',desc: '',items: [{key: 'count_1',name: '1次以上'},{key: 'count_2',name: '2次以上'},{key: 'count_3',name: '3次以上'}] }
      _options << {multi:false, key: 'night',name: '有夜消费习惯',desc: '',items: [{key: 'night_0',name: '无'},{key: 'night_1',name: '1次以上'},{key: 'night_2',name: '2次以上'}] }

      _options
    end
    
    def calc_member_count _config = {}
      config = {}
      _config.each do |key, value|
        config[key.to_sym] = value
      end
      
      puts "city:#{config}"
      
      city = Mp::GroupCity.find_by code: (config[:city]||'').gsub('city_','')
      GroupProperty.store_in_collection(city.pinyin)
      
      current = GroupProperty
      %w{city sex category consume count night}.each do |key|
        puts "key:#{key}"
        item = config[key.to_sym]
        if item.present?
          item = item.join(',') if item.is_a?(Array)
          value = item.gsub("#{key}_",'')
          puts "value:#{value}"
          next if value=='bx'
          if value.present?
            value = value.to_i unless %w{category city}.include?(key)
            case key
            when 'city'
              puts "zone:"
              current = current.where(zone: value)
            when 'sex'
              puts "sex"
              current = value.to_i ==1 ? current.where(:sex.gte => 0.7) : current.where(:sex.lt => 0.7)
            when 'category'
              puts "category"
              category_ids = value.split(',').map {|item| item.to_i}
              current = current.any_in(labels: category_ids)              
            when 'consume'
              puts "consume"
              current = current.where(:gain_month.gt => value)
            when 'count'
              puts "count"
              current = current.where(:count_month.gt => value)
            when 'ngiht'
              puts "ngint"
              if value == 0
                current = current.where(count_night: 0)
              else
                current = current.where(:count_night.gt => value)
              end
            end
          end
        end
      end
      token = config[:token]
      dir = "#{Rails.root}/public/uploads/attachment/mongo"
      FileUtils.mkdir_p dir unless File.exist?(dir)
      file = "#{dir}/#{token}"
      puts "save to file:#{file}"
      File.open(file, 'w+') { |file| file.write(config.to_json) }
      Attachment.create ref_clazz: 'mongo',file: token,token: token,atta_path: file
      current.count
      # count
    end
  end

  index({zone: 1})
end