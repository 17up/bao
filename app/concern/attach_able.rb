#encoding: utf-8

module AttachAble
  extend ActiveSupport::Concern
  
  included do |base_class|
    has_many :attaches,->{where ref_clazz: base_class.to_s.underscore},class_name: 'Attachment',foreign_key:  'ref_id'
    mount_uploader :file, AttachmentUploader
  end
  
  module ClassMethods
  end

end