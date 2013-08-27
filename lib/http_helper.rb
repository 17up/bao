module HttpHelper
  def post_nexus api_method, program_code, _params = {}, _server_params={}
    p = _params.merge({programCode: program_code}).map { |key, value| "#{key}=#{value}" }.join('&')
    res = Net::HTTP.start("#{_server_params[:server]||NEXUS_API_SERVER}", "#{_server_params[:port]||NEXUS_API_PORT}") do |http|
      http.get("/nexus/#{api_method}?#{p}")
    end

    r = JSON.parse res.body
    if r['err']=='0000'
      return 0, 'ok'
    else
      return -1, r['msg']
    end
  end

  def parse_result content
    r = JSON.parse content
    if r['err']=='0000'
      return 0, 'ok'
    else
      return -1, r['msg']
    end

  rescue => e
    return -1, e.inspect
  end
end