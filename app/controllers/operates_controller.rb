# -*- coding: utf-8 -*-
class OperatesController < ApplicationController
  PAGE_PER = 20


  def check
    store_id = current_member.store_id
    start_date, end_date = require_date

    data = OperatesStore.get(store_id, action_name, start_date, end_date)
    if data
      logger.debug "---------------#{store_id}-#{action_name}-pluck-at-redis------------------"
      return render_json 0,"ok",data
    end

    data = OperatesService.check(store_id, start_date, end_date)
    render_json 0,"ok",data
    OperatesStore.save(store_id, action_name, start_date, end_date, data)
  end

  def latestoverview
    store_id = current_member.store_id
    book = Operate::StoreBook.where(store_id: store_id).order("the_day desc").first
    if book && (the_day = book.the_day)
      start_date = the_day.at_beginning_of_month.to_date
      end_date = the_day.end_of_month.to_date
    else
      one_month_ago = 1.month.ago
      start_date = one_month_ago.at_beginning_of_month.to_date
      end_date  = one_month_ago.end_of_month.to_date
    end

    data = OperatesStore.get(store_id, action_name, start_date, end_date)
    if data
      logger.debug "---------------#{store_id}-#{action_name}-pluck-at-redis------------------"
      return render_json 0,"ok",data
    end

    data = OperatesService.latestoverview(store_id, start_date, end_date)

    render_json 0,"ok",data
    OperatesStore.save(store_id, action_name, start_date, end_date, data)
  end

  def overview
    store_id = current_member.store_id
    start_date, end_date = require_date

    data = OperatesStore.get(store_id, action_name, start_date, end_date)
    if data
      logger.debug "---------------#{store_id}-#{action_name}-pluck-at-redis------------------"
      return render_json 0,"ok",data
    end

    data = OperatesService.overview(store_id, start_date, end_date)
    render_json 0,"ok",data
    OperatesStore.save(store_id, action_name, start_date, end_date, data)
  end


  def dealrecord
    store_id = current_member.store_id
    start_date, end_date = require_date

    data = OperatesStore.get(store_id, action_name, start_date, end_date)
    if data
      logger.debug "---------------#{store_id}-#{action_name}-pluck-at-redis------------------"
      return render_json 0,"ok",data
    end

    data = OperatesService.dealrecord(store_id, start_date, end_date)

    render_json 0,"ok",data
    OperatesStore.save(store_id, action_name, start_date, end_date, data)
  end

  def feature
    store_id = current_member.store_id
    start_date, end_date = require_date

    data = OperatesStore.get(store_id, action_name, start_date, end_date)
    if data
      logger.debug "---------------#{store_id}-#{action_name}-pluck-at-redis------------------"
      return render_json 0,"ok",data
    end

    data = OperatesService.feature(store_id, start_date, end_date)

    render_json 0,"ok",data
    OperatesStore.save(store_id, action_name, start_date, end_date, data)
  end

  def dealflow
    store_id = current_member.store_id
    begin_date, end_date = require_date
    @storebooks = Operate::StoreBook.where(store_id: store_id).where(the_day: begin_date..end_date).page(params[:page]).per(PAGE_PER)

    data = {
        begin_date: begin_date,
        end_date: end_date,
        storebooks: @storebooks.as_json,
        pagination_str: render_to_string(:template => "shared/_pagination",:locals => {:collection => @storebooks},:layout => false)
    }
    render_json 0,"ok",data
  end

  private

  def require_date
      before = 1.month.ago
      default_end_date = Date.strptime("#{before.year}-#{before.month}", "%Y-%m").end_of_month.to_date
      after = 3.months.ago
      default_begin_date  = Date.strptime("#{after.year}-#{after.month}", "%Y-%m").at_beginning_of_month.to_date
      begin_date = params[:begin_date].present? ?  Date.strptime(params[:begin_date], "%Y-%m").at_beginning_of_month.to_date : default_begin_date
      end_date = params[:end_date].present? ? Date.strptime(params[:end_date], "%Y-%m").end_of_month.to_date : default_end_date
      return begin_date,end_date
  end
end
