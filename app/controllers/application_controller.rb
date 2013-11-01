#encoding: utf-8

class ApplicationController < ActionController::Base
  include ExceptionLogger::ExceptionLoggable 
  rescue_from Exception, :with => :log_exception_handler
  
	before_filter :authenticate_member!
  
  include AppHelper
  protect_from_forgery
end