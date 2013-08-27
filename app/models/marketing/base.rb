# -*- coding: utf-8 -*-
module Marketing
  class Base < ActiveRecord::Base
    attr_accessible :program_id, :store_id
    self.table_name = "_marketings"
    has_many :indicators, class_name: Marketing::Indicator
    has_many :reportconvdetails, class_name: Marketing::ReportConvDetail

    attr_accessible *column_names.reject{ |key,val| key.to_sym == :id }.map{ |key,val| key.to_sym}

    class << self

      def attention(store_id,start_date,end_date)
        arr = Array.new
        find_each(conditions: {store_id: store_id}) do | market|
          arr << market.attention(start_date,end_date)
        end
        arr.transpose.map{ |x| x.reduce(&:+) }
      end

      def exposure(store_id,start_date,end_date)
        arr = Array.new
        find_each(conditions: {store_id: store_id}) do | market|
          arr << market.exposure(start_date,end_date)
        end
        arr.transpose.map{ |x| x.reduce(&:+) }
      end

      def tick_count(store_id,start_date,end_date)
        arr = Array.new
        find_each(conditions: {store_id: store_id}) do | market|
          arr << market.tick_count(start_date,end_date)
        end
        arr.transpose.map{ |x| x.reduce(&:+) }
      end

      def tick_amount(store_id,start_date,end_date)
        arr = Array.new
        find_each(conditions: {store_id: store_id}) do | market|
          arr << market.tick_amount(start_date,end_date)
        end
        arr.transpose.map{ |x| x.reduce(&:+) }
      end

    end
  end
end