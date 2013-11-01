#encoding: utf-8

class AccountsController < ApplicationController
  def change_password   
   @account.change_password params
   
   if @account.succ?
     render_with_json data:{id: @account.id}
   else
     render_with_json status: -1,msg: get_record_errors(@account)
   end
  end
  
  protected
  def init_params
    @id = params[:id]||params[:account_id]
    @account = Account.find @id if @id.present?
  end
end
