# -*- coding: utf-8 -*-
class WelcomeController < ApplicationController
	before_filter :authenticate_member!

	def index
	  	@title = "银联智惠宝"
	end
  
end