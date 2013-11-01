class MerchantCategoriesController < ApplicationController
  def select
    @categories = MerchantCategory.where(parent_id: @id)
    render_with_json data: @categories
  end
end