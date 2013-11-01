class Mp::MemberPlan < ActiveRecord::Base
	self.table_name = "member_plans"
  	attr_accessible :member_id, :plan_id

  	belongs_to :member
    belongs_to :program,class_name: 'Nexus::Program',foreign_key: 'plan_id'
    
    validates :member_id, :presence => true
    validates :plan_id, :presence => true, :uniqueness => {:scope => :member_id}
end