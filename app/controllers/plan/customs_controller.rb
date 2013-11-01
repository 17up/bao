class Plan::CustomsController < Plan::BaseController
  def index
    render_paginate current_member.programs({page: @page, program_type: current_member.admin? ? 6 : 4})
  end

  def filter_user
    attachment = upload_attachment
    render_with_json data: {count: attachment.count_line.to_i, label: plan_label, store_id: params[:store_id]}
  end
  
  def edit
    @program = Nexus::Program.find params[:id]
    render_with_json data: @program.as_show_json.merge({count: count.to_i, label: plan_label})
  end
  
  
  def count
    @program.attachment_line_count# unless @program.nil?
  end
  
  def create
    if check_black_word
      if current_member.admin?
        super
      else
        if params[:program_id].present?
          @program = Nexus::Program.find params[:program_id]
          @plan = current_member.update_custom_plan @program.plan, params
        else
          @plan = current_member.create_custom_plan params.merge(plan_type: 4)
        end

        if @plan.succ?
          render_with_json
        else
          render_with_json status: -1, msg: get_record_errors(@plan)
        end
      end
    end
  end
end