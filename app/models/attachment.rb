#encoding: utf-8

class Attachment < ActiveRecord::Base
  extend  AppHelper
  include AttachAble
  # belongs_to :merchant
  # belongs_to :store
  # belongs_to :user  
  
  attr_accessible *column_names,:file
  
  mount_uploader :file, AttachmentUploader
  before_save :set_attachment_attributes
  
  def attach_file_path
    "#{Rails.root}/public#{file.url}"
  end
  
  class<<self    
    def create_file config,member
      unless config[:file].nil?
        store = Mp::Store.find config[:store_id]
        Attachment.create file: config[:file],user_id: member.id,merchant_id: store.merchant_id,store_id: store.id,
                ref_clazz: current_controller_name(config),token: config[:token],ref_id: config[:ref_id]
      else
        puts "name is null,ignore"
        Attachment.new
      end
    end
  end
    
  def count_line
    file.path.nil? ? 0 :  `wc -l #{file.path}`.split.first rescue 0
  end 
  
  #patch for CarrierWave
  def file_will_change!
    #nogthing
  end

  protected
  def set_attachment_attributes
    if file.present? && file_changed?
      self.atta_type = file.file.content_type
      self.atta_size = file.file.size
      self.atta_name = file.file.original_filename
      self.atta_path = file.file.path
    end
  end
end
