#encoding: utf-8

class Plan::PersonalsController < Plan::BaseController
  def index
    render_paginate current_member.programs({page: @page, program_type: 5})
  end

  def new
    data = {options: GroupProperty.options,token: SecureRandom.uuid.gsub("-","")}
    render_with_json data: data
  end
  
  
  def edit
    @program = Nexus::Program.find params[:id]
    @plan = @program.plan
    if @plan.crete_by_merchant?
      data = {options: Mp::PlanOption.list, city: current_member.city_name, personal: current_merchant.count_personal(@program), custome: current_merchant.count_custome(@program)}
    else
      data = {count: count.to_i, label: plan_label}
    end
      
    data.merge! @program.as_show_json
    
    render_with_json data: data
  end

  def options
    @program = Nexus::Program.find params[:id] if params[:id].present?
    
    data = {options: Mp::PlanOption.list, city: current_member.city_name, personal: current_merchant.count_personal(@program), custome: current_merchant.count_custome(@program)}
    
    data.merge! @program.as_show_json if @program.present?
    render_with_json data: data
  end

  def filter_user
    if current_member.admin?
      render_with_json data: {count: "#{GroupProperty.calc_member_count params}".to_i, personal: -1, custome: -1,label: plan_label, store_id: params[:store_id]}
    else
      render_with_json data: {count: "#{Mp::PlanOption.calc_member_count(params)}万", personal: current_merchant.count_personal, custome: current_merchant.count_custome, store_id: params[:store_id]}
    end
  end

  def create
    if check_black_word
      if current_member.admin?
        super
      else
        if params[:program_id].present?
          @program = Nexus::Program.find params[:program_id]
          @plan = current_member.update_personal_plan @program.plan, params
        else
          @plan = current_member.create_personal_plan params.merge(plan_type: 5)
        end

        if @plan.succ?
          render_with_json
        else
          render_with_json status: -1,msg: get_record_errors(@plan)
        end
      end
    end
  end
  
  def count
    @program.personal_line_count# unless @program.nil?
  end
end
