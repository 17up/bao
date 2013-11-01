# coding: utf-8

module AppHelper

  def self.included base
    base.send :before_filter, :init_page_variables, :init_constants,:init_params,:check_merchant_package if base.respond_to? :before_filter
  end


  def check_merchant_package
    merchant = current_merchant
    puts "*** check_merchant_package:#{merchant.try :name}"
    if merchant.present?
      puts "*** merchant status:#{merchant.status},end in:#{merchant.package_end}"
      @error_message = nil
      
      flash[:error] = "商户状态异常:#{merchant.status_name}，请联系客服" unless merchant.approved? 
      
      if merchant.package_end.blank?
         flash[:error]  = "商户套餐有效期异常，请联系客服"
      else
        flash[:error]  = "套餐已于过期，如有疑问请联系客服" unless merchant.package_end >= Time.now
      end
        #todo:
      if flash[:error] .blank?
        
      else
        puts "*** #{flash[:error]}"
        puts "*** invalid status,destroy session"
        
        sign_out current_member
        redirect_to new_member_session_url
      end
    end
  end
  
  def current_merchant
    # if current_member.agent?
      @current_merchant = Mp::Merchant.unscoped{Mp::Merchant.find_by mch_id: current_member.merchant_id} if current_member.present?
    # else
      # @current_merchant ||= current_member.merchant
    # end
  end
  
  def init_params
    @id = params[:id]
  end
  
  def upload_attachment(name='file')
    Attachment.create_file params.merge(attachment_param_name: name), current_member
  end
  
  def init_constants
  end

  def init_page_variables
    @title = "银联智惠宝"
    @admin = current_member.admin? if current_member

    @id = params[:id]
    @page = params[:page]||1
  end

  def render_json status=0, msg="ok", data = {}
    render json: {status: status, msg: msg, data: data}
  end

  def render_with_json config = {}
    json =({status: config[:status]||0, msg: config[:msg]||'ok'}).merge(config)
    render json: json
  end

  def user_for_paper_trail
    current_member
  end

  def get_record_errors r
    str = []

    if r && r.respond_to?(:errors)
      _obj_name = r.class.to_s.downcase

      unless  r.errors.messages.empty?
        r.errors.messages.each do |key, value|
          _obj_name =  _obj_name.gsub('/','.').gsub('::','.').split('.').last
          str << "#{t "activerecord.attributes.#{_obj_name}.#{key}"}#{value.first}" unless value.empty?
        end
      end
    end

    str.join(",")
  end

  def current_controller
   controller_name.singularize
  end

  def current_controller_name config
    config.is_a?(Hash) ? config[:controller].split("/").last.singularize : config.split("/").last.singularize
  end

  def current_action
  end

  def time_to_str time=Time.now, format="%Y-%m-%d %H:%M:%S"
    time.strftime(format) unless time.nil?
  rescue => e
    time
  end
end