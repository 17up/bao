class Mp::StoreCost < ActiveRecord::Base
	self.table_name = "_store_cost_info"
	attr_accessible :day, :count, :gain
	belongs_to :store,:class_name => "Mp::Store",:foreign_key => "store_id"


end