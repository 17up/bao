#encoding: utf-8

module AuditAble
  extend ActiveSupport::Concern
  
  included do |base_class|

    
    def pending?
      status == 'pending'
    end

    def approved?
      status == 'approve'
    end

    def reject?
      status == 'reject'
    end
  
    def freezed?
      status == 'freezed'
    end
    
    def freeze!
      self.update_attributes status: 'freezed'
    end
    
    def restore!
      self.update_attributes status: 'approve'
    end
    
    def status
      (read_attribute(:status)||'').downcase
    end
  
    def status=(_status)
      write_attribute :status,(_status||'').downcase
    end

    def status_name
      AUDIT_STATUS[status.to_sym]
    end
   
    def freeze_status
      if pending? || reject?
        -1
      else
        freezed? ? 1 : 0
      end
    end
  end
  
  module ClassMethods
  end

end