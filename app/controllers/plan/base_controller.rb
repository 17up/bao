#encoding: utf-8

class Plan::BaseController < ApplicationController
  
  def render_paginate collection,paginate_collection=nil
    paginate_collection = collection if paginate_collection.nil?
    data = []
    if collection &&  !collection.empty?
      collection.compact!
      data = {
        programs: collection.map(&:as_short_json),
        pagination_str: render_to_string(:template => "shared/_pagination",:locals => {:collection => paginate_collection},:layout => false)
      }
    end
    render_with_json data: data
  end

  def new
    render_with_json data: {token: SecureRandom.uuid.gsub("-","")}
  end
  
  def edit
    @program = Nexus::Program.find params[:id]
    render_with_json data: @program.as_show_json.merge({count: count.to_i, label: plan_label})
  end
  
  def preview
    if check_black_word
      invalid_codes =  check_reply_code
      if invalid_codes.empty?
        push_number = (params[:push_number_perday]||[]).map{|x| x.to_i}.sum#*cnt
        opts = {
          has_upset: params[:has_upset].present?,
          push_number: push_number
        }
        data = params.merge(opts)
        render_with_json data: data
      else
        render_with_json status: -1,msg: "以下上行内容已经被使用:#{invalid_codes.join(',')}，请使用其他上行内容"
      end
    end
  end

  def filter_user
    render_with_json data: {count: count.to_i, label: plan_label, store_id: store_id}
  end


  def count 
    Mp::Customer.count_by store_id: @program.nil? ? params[:store_id] : @program.store_id,label: current_controller
  end
  
  def store_id
    params[:store_id]
  end
  
  def options
    render_with_json
  end

  def mobiles
    @program = Nexus::Program.find(params[:id]||params[:custom_id])
    data = {
      push_content: @program.plan.target.try(:sms_content),
      mobiles: @program.mobiles
    }
    render_with_json data: data
  end

  def create
    if check_black_word
      invalid_codes =  check_reply_code
      if invalid_codes.empty?
        @plan = Nexus::PlanInfo.save_plan current_member,params

        if @plan.succ?
          render_with_json
        else
          render_with_json status: -1,msg: get_record_errors(@plan)
        end
      else
        render_with_json status: -1,msg: "以下上行内容已经被使用:#{invalid_codes.join(',')}，请使用其他上行内容"
      end
    end
  end

  protected
  def check_black_word msg=nil
    flag,word = BlackWord.valid? msg||params[:push_content]
    if flag
      true
    else
      render_with_json status: -1,msg: "短信文案中存在敏感词:#{word}，请修正后再提交"
      return
    end
  end
  
  def check_reply_code
    invalid_codes = []
    (params[:reply_code]||[]).each do |code|
      next if code.blank?
      invalid_codes<< code unless Nexus::SmsReply.available?(code,params)
    end
    
    invalid_codes
  end
  
  def plan_label
    Nexus::PlanInfo.plan_label params[:controller]
  end
  

end
