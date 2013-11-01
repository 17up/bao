class Api::Store2merchantController < ApplicationController
  skip_before_filter :authenticate_member!
  def notify
    p, sign = params[:p], params[:sign]
    unless sign == Digest::MD5.hexdigest("Upsmart#{p}")
      return render_to_json 101, "params invaild!"
    end
    json = JSON.parse(p)
    store_id,merchant_id = json["store_id"],json["merchant_id"]
    if (store = MP::Store2merchant.where(store_id: store_id).first)
      store.update_attributes(merchant_id: merchant_id)
      return render_to_json 001, "updated store_id!"
    else
      MP::Store2merchant.create(merchant_id: merchant_id, store_id: store_id)
      return render_to_json 002, "been notified!"
    end
  end

  def weidian
    store_id = current_member.store_id
    store2merchant = MP::Store2merchant.where(store_id: store_id).first
    render_json 0,"ok",{
                  merchant_id: store2merchant && store2merchant.merchant_id || 1,
                  merchant_src: Settings.weidian_merchant_src
                }
  end

  private
  def render_to_json(status="000",msg="ok")
    render json: {status: status, msg: msg}
  end

end
