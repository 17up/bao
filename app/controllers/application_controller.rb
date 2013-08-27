class ApplicationController < ActionController::Base
  include AppHelper

  protect_from_forgery
end
