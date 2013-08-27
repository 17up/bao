#coding: utf-8
class Mp::Role < ActiveRecord::Base
	self.table_name = "_role_info"
	attr_accessible :role_name, :role_multi_store, :role_all_store, :role_store_info_page

	has_many :member, :class_name => "Mp::Member",:foreign_key => "role"
end