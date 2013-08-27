#encoding: utf-8

module AuthenticationConcern
    extend ActiveSupport::Concern
    
    # 
    # def self.included base
    #    base.extend ClassMethods
    # end
    #
     
    def self.included base
       attr_accessor :login
  
       base.validates :user_name, :uniqueness => true
       base.validates :mobile, :uniqueness => true, :allow_nil => true  
        
       base.class_eval do
         def self.find_for_database_authentication(conditions)
           email_name_regex  = '[\w\.%\+\-]+'.freeze
           domain_head_regex = '(?:[A-Z0-9\-]+\.)+'.freeze
           domain_tld_regex  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
           email_regex       = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i

           logger.debug "find_for_database_authentication:#{conditions.inspect}"
           p conditions
           
           login = conditions.delete :login
           #todo:will be removed
           login = conditions.delete :email if login.blank?
           # conditions = nil
           u = nil
        
           if  login =~ /^\d+$/ && login.length == 11
             u = where(conditions).where(mobile: login).first
           elsif login =~ email_regex 
             u = where(conditions).where(email: login).first
           end
           
           u = where(conditions).where(user_name: login).first if u.nil?
         
           u
         end
       end
    end
end