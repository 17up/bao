class Mp::MemberStore < ActiveRecord::Base
	self.table_name = "_store_member_relation"

  	attr_accessible :member_id, :store_id
  	belongs_to :member
  	belongs_to :store
  	validates :member_id, :presence => true
    validates :store_id, :presence => true, :uniqueness => {:scope => :member_id}

end