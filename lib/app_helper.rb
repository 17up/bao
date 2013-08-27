# coding: utf-8

module AppHelper

  def self.included base
    base.send :before_filter, :init_page_variables, :init_constants if base.respond_to? :before_filter
  end

  def init_constants
  end

  def init_page_variables
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
          str << "#{t "activerecord.attributes.#{_obj_name}.#{key}"}#{value.first}" unless value.empty?
        end
      end
    end

    str.join(",")
  end

  def time_to_str time=Time.now, format="%Y-%m-%d %H:%M:%S"
    time.strftime(format) unless time.nil?
  rescue => e
    time
  end
end