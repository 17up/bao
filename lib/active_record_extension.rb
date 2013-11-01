#encoding: utf-8

module ActiveRecordExtension

  extend ActiveSupport::Concern
  
  def succ?
    errors.messages.empty? rescue true
  end
  
  def fmt_cur p
    sprintf("%0.2f", p)
  rescue
    '0.00'
  end
  
  def trim content,trim_space=true
    return "" if content.blank?
    ["\r\n", "\t", "\r", "\n", "$"].each do |c|
      content = content.gsub(c, "")
    end
    
    content = content.gsub(" ", "") if trim_space
     
    content
  rescue => e
    content
  end
  
  
  module ClassMethods
    def trim content,trim_space=true
      return "" if content.blank?
      ["\r\n", "\t", "\r", "\n", "$"].each do |c|
        content = content.gsub(c, "")
      end
    
      content = content.gsub(" ", "") if trim_space
     
      content
    rescue => e
      content
    end
  end
  
end

ActiveRecord::Base.send(:include, ActiveRecordExtension)