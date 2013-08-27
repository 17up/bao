#encoding: utf-8

class Plan::PersonalsController < ApplicationController
  def index
    render_with_json data: nil
  end

  def options
    render_with_json data: {options: Mp::PlanOption.list, city: current_member.city_name}
  end

  def filter_user
    render_with_json data: {count: "#{Mp::PlanOption.calc_member_count(params)}万", personal: '100', custome: '100'}
  end

  def preview
    render_with_json data: params
  end

  def create
    @plan = current_member.create_plan params.merge(plan_type: 5)
    if @plan.succ?
      render_with_json
    else
      render_with_json status: -1,msg: get_record_errors(@plan)
    end
  end
end