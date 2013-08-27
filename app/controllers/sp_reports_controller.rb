class SpReportsController < ApplicationController
	before_filter :authenticate_member!

	# list view
	def index
		data = current_member.programs.map(&:as_short_json)
		render_json 0,"ok",data
	end

	def summary
		program = Nexus::Program.find(params[:id])
		data = program.as_full_json
		render_json 0,"ok",data
	end

	def detail
		page = params[:page] || 1
		program = Nexus::Program.find(params[:id])
		@sps = program.reports.success.order("push_time desc").page(page).per(Nexus::SpReport::PER_PAGE)
		
		data = {
			detail: @sps.as_json,
			pagination_str: render_to_string(:template => "shared/_pagination",:locals => {:collection => @sps},:layout => false)
		}
		render_json 0,"ok",data
	end

end
