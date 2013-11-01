#encoding: utf-8

class OrdersController < ApplicationController
	def index
		@orders = Order.search current_member,params
		@merchant = current_merchant
		data = {
			orders: @orders,
			amount: @merchant.amount,
			merchant_name: @merchant.mch_name,
			merchant_id: @merchant.id,
			pagination_str: render_to_string(:template => "shared/_pagination",:locals => {:collection => @orders},:layout => false)
		}

		render_with_json data: data
	end

	def show
		render_with_json data: @order.first.try(:as_json_for_show)
	end

	def create
		@type = params[:type]||'merchant'

		if @type == 'merchant' && (params[:merchant_id]||[]).empty?
			render_with_json status: -1,msg: '至少选择一个商户'
    elsif  @type == 'self' && (params[:price]||params[:number]).to_i<=0
			render_with_json status: -1,msg: '充值金额非法'
		else
			@order = Order.send "charge_for_#{@type}".to_sym,current_member,params
			if @order.succ?
				render_with_json data: @order.as_json_for_show
			else
				render_with_json status: -1,msg: get_record_errors(@order)
			end
		end
	end

	protected
	def init_params
		super
		@order = Order.where(id: @id).includes(:order_items,:merchant,order_items: [:merchant,:package]) if @id.present?
	end
end

