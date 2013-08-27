# -*- coding: utf-8 -*-
class MarketingsController < ApplicationController

  def summary
    #store_id, program_code,plan_name = params[:store_id], params[:program_code], params[:plan_name]
    store_id = current_member.store_id
    program_code = "SMS"
    plan_name = "方案名称"
    begin_date,end_date = require_date
    chart_data = {
      attention: Marketing::Base.attention(store_id, begin_date, end_date),
      exposure: Marketing::Base.exposure(store_id, begin_date, end_date),
      tick_count: Marketing::Base.tick_count(store_id, begin_date, end_date),
      tick_amount: Marketing::Base.tick_amount(store_id, begin_date, end_date),
    }

    daily_data = Array.new
    (begin_date..end_date).each_with_index do |the_day,idx|
      daily_data << [the_day, chart_data[:exposure][idx], chart_data[:attention][idx], chart_data[:tick_count][idx], chart_data[:tick_amount][idx]]
    end

    data = {
      store_id: store_id,
      begin_date: begin_date,
      end_date: end_date,
      attention: Marketing::Base.attention(store_id, begin_date, end_date).reduce(&:+),
      exposure: Marketing::Base.exposure(store_id, begin_date, end_date).reduce(&:+),
      tick_count: Marketing::Base.tick_count(store_id, begin_date, end_date).reduce(&:+),
      tick_amount: Marketing::Base.tick_amount(store_id, begin_date, end_date).reduce(&:+),
      chart_data: chart_data,
      daily_data: daily_data
    }
    render_json 0,"ok",data
  end

  def convs
    #store_id, program_code,plan_name = params[:store_id], params[:program_code], params[:plan_name]
    begin_date,end_date = require_date
    store_id = current_member.store_id
    #_marketings_id = params[:id]
    store_id = current_member.store_id
    # _marketings_id = Marketing::Base.where(store_id: store_id,program_code: program_code)
    @convs =  Marketing::ReportConvDetail.where(_marketings_id: Marketing::Base.where(store_id: store_id), trans_rcv_ts: begin_date..end_date.next).page(params[:page]).per(50)
    data = {
      detail: @convs.as_json,
      pagination_str: render_to_string(:template => "shared/_pagination",:locals => {:collection => @convs},:layout => false)
    }
    render_json 0,"ok",data
  end

  def follows
    #store_id, program_code,plan_name = params[:store_id], params[:program_code], params[:plan_name]
    begin_date,end_date = require_date
    store_id = current_member.store_id
    # _marketings_id = Marketing::Base.where(store_id: store_id,program_code: program_code)
    @follows =  Marketing::ReportFollowDetail.where(_marketings_id: Marketing::Base.where(store_id: store_id), care_time: begin_date..end_date.next).page(params[:page]).per(50)
    data = {
      detail: @follows.as_json,
      pagination_str: render_to_string(:template => "shared/_pagination",:locals => {:collection => @follows},:layout => false)
    }
    render_json 0,"ok",data

  end


  def follow
    #store_id, program_code,plan_name = params[:store_id], params[:program_code], params[:plan_name]
    begin_date,end_date = require_date
    _marketings_id = params[:id]
    # _marketings_id = Marketing::Base.where(store_id: store_id,program_code: program_code)
    @follows =  Marketing::ReportFollowDetail.where(_marketings_id: _marketings_id, care_time: begin_date..end_date.next).page(params[:page]).per(50)

    data = {
      detail: @follows.as_json,
      pagination_str: render_to_string(:template => "shared/_pagination",:locals => {:collection => @follows},:layout => false)
    }
    render_json 0,"ok",data
  end

  def conv
    #store_id, program_code,plan_name = params[:store_id], params[:program_code], params[:plan_name]
    begin_date,end_date = require_date
    _marketings_id = params[:id]
    # _marketings_id = Marketing::Base.where(store_id: store_id,program_code: program_code)
    @convs =  Marketing::ReportConvDetail.where(_marketings_id: _marketings_id, trans_rcv_ts: begin_date..end_date.next).page(params[:page]).per(50)
    data = {
      detail: @convs.as_json,
      pagination_str: render_to_string(:template => "shared/_pagination",:locals => {:collection => @convs},:layout => false)
    }
    render_json 0,"ok",data
  end

  def detail
    #store_id, program_code,plan_name = params[:store_id], params[:program_code], params[:plan_name]
    begin_date,end_date = require_date
    _marketings_id = params[:id]
    # _marketings_id = Marketing::Base.where(store_id: store_id,program_code: program_code)
    marketing = Marketing::Base.find(_marketings_id)
    attention = case marketing
    when Marketing::Sms
      {
        reply_count: marketing.reply_count(begin_date, end_date),
        clicked_count: marketing.clicked_count(begin_date, end_date)
      }
    when Marketing::Weidian
      {
        follows: marketing.reply_count(begin_date, end_date)
      }
    end
    chart_data = {
      attention: attention,
      exposure: marketing.exposure(begin_date, end_date),
      tick_count: marketing.tick_count(begin_date, end_date),
      tick_amount: marketing.tick_amount(begin_date, end_date),
    }

    daily_data = Array.new
    (begin_date..end_date).each_with_index do |the_day,idx|
      case marketing
      when Marketing::Sms
        daily_data << [the_day, chart_data[:exposure][idx], [chart_data[:attention][:reply_count][idx],chart_data[:attention][:clicked_count][idx]], chart_data[:tick_count][idx], chart_data[:tick_amount][idx]]
      when Marketing::Weidian
        daily_data << [the_day, chart_data[:exposure][idx], [chart_data[:attention][:follows][idx]], chart_data[:tick_count][idx], chart_data[:tick_amount][idx]]
      end
    end

    data = {
      store_id: current_member.store_id,
      begin_date: begin_date,
      end_date: end_date,
      attention: marketing.attention(begin_date, end_date).reduce(&:+),
      exposure: marketing.exposure(begin_date, end_date).reduce(&:+),
      tick_count: marketing.tick_count(begin_date, end_date).reduce(&:+),
      tick_amount: marketing.tick_amount(begin_date, end_date).reduce(&:+),
      chart_data: chart_data,
      daily_data: daily_data
    }
    render_json 0,"ok",data
  end

  private

  def require_date
      begin_date = params[:begin_date].present? ? Date.parse(params[:begin_date]) : 30.days.ago.to_date
      end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.yesterday
      return begin_date,end_date
  end

end