class NameListsController < ApplicationController
  before_filter :init_name_list

  def index
    @namelist = current_member.name_lists.order(created_at: :desc).page(params[:page]).per(10)
    data = {
      list: @namelist,
      pagination_str: render_to_string(:template => "shared/_pagination",:locals => {:collection => @namelist},:layout => false)
    }
    render_with_json data: data
  end

  def mobiles
    render_with_json data: Mp::NameMobile.list_mobiles(@name_list)
  end

  def create
    current_member.create_name_list params
    render_with_json
  end

  def destroy
    @name_list.destroy
    render_with_json
  end

  private
  def init_name_list
    @id = params[:id]||params[:name_list_id]
    @name_list = Mp::NameList.find @id unless @id.blank?
  end
end