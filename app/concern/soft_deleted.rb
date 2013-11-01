module SoftDeleted
    extend ActiveSupport::Concern
  
    included do |base_class|
      default_scope {where("#{self.table_name}.deleted_at is null")}    
    end
  
    module ClassMethods
    end
  
end