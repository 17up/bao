#encoding: utf-8

class PackageOrderHistory < ActiveRecord::Base
  include  AuditAble
  include  SoftDeleted

  attr_accessible *column_names
  
  belongs_to :package_order
  belongs_to :order
  belongs_to :order_item
  belongs_to :merchant
  belongs_to :package
  
  scope :history,->(program_id){where(program_id: program_id,parent_id: nil)}
  
  class<<self    
    def with_draw program_id,is_merchant 
      if is_merchant
        histories = PackageOrderHistory.where(program_id: program_id)
        histories.each do |h|
          next if h.parent_id.blank?
          _order = h.package_order
          _order.update_attributes used: (_order.used - h.count)
        end
      end
      
      histories.update_all deleted_at: Time.now,deleted: true,status: 'delete' unless histories.nil?
    end
  end
end