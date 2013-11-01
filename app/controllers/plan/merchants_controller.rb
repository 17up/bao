class Plan::MerchantsController < Plan::BaseController
  def filter_user
    attachment = upload_attachment
    render_with_json data: {count: 1000000, label: plan_label, store_id: params[:store_id]}
  end
  
  def edit
    @program = Nexus::Program.find params[:id]
    render_with_json data: @program.as_show_json.merge({count: 1000000, label: plan_label})
  end
end
