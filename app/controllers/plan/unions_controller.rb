#encoding: utf-8

class Plan::UnionsController < Plan::BaseController
  def index
    plans = current_member.union_programs({page: @page})
    render_paginate plans.collect(&:program),plans
  end
end