#encoding: utf-8

class Plan::PlansController < Plan::BaseController
  def index
    if current_member.upsmart?
      render_paginate current_member.programs({page: @page})
    else
      render_paginate current_member.programs({page: @page, category_name: 'upsmart'})
    end
  end
end