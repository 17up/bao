class Plan::ModelsController < Plan::BaseController
  def filter_user
    render_with_json data: {count: 1000000, label: plan_label, store_id: params[:store_id]}
  end
  
  
  def edit
    @program = Nexus::Program.find params[:id]
    render_with_json data: @program.as_show_json.merge({count: 1000000, label: plan_label})
  end
end