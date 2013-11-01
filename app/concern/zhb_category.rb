#coding: utf-8

module ZhbCategory
  extend ActiveSupport::Concern

  included do |base_class|
    def upsmart?
      'upsmart' == category_name
    end

    def agent?
      'agent' == category_name
    end

    def merchant?
      'merchant' == category_name
    end

    def admin?
      upsmart?
    end

    def category_integer
      case category_name
      when 'upsmart'
        1
      when 'agent'
        2
      when 'merchant'
        3
      else
        4
      end
    end
    # alias upsmart? admin?
  end
end