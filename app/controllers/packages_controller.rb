class PackagesController < ApplicationController
  
  def basic
    @packages = Package.basics
    render_with_json data: @packages
  end
  
  alias basic_for_select basic
  
  def added
    @packages = Package.added
    render_with_json data: @packages
  end
  
  def promos
    @promos = PackagePromo.all
    render_with_json data: @promos
  end
  
  def promo_price
    render_with_json data: @package.promo_price(params[:count],true)
  end
    
  alias cal_total_price promo_price
  
  protected
  def init_params
    super
    @package = Package.find @id if @id.present?
  end
end
