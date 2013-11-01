class AgentsController < ApplicationController
  def index
    @agents = Agent.search params
    data = {
      agents: @agents.map{|m|m.as_list_json},
      pagination_str: render_to_string(:template => "shared/_pagination",:locals => {:collection => @agents},:layout => false)
    }
    render_with_json data: data
  end
  
  alias list index

  def create
    @agent = Agent.save_agent current_member,params

    if @agent.succ?
      render_with_json data: @agent
    else
      render_with_json status: -1,msg: get_record_errors(@agent)
    end
  end

  alias update create

  def show
    render_with_json data: {stores: @agent,info: @agent}
  end

  def bind_account
    @member = @agent.bind_account current_member,params
    if @member.succ?
      render_with_json data:{id: @agent.id}
    else
      render_with_json status: -1,msg: get_record_errors(@member)
    end
  end

  def freeze_agent
    @agent.freeze!
    render_agent
  end

  def restore_agent
    @agent.restore!
    render_agent
  end


  protected
  def render_agent
    render_with_json data: @agent.as_list_json
  end

  def init_params
    super
    @id = params[:id]||params[:agent_id]
    @agent = Agent.where(mch_id: @id).includes(:first_account,:city,:category).first if @id.present?
  end
end
