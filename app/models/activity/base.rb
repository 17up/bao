# -*- coding: utf-8 -*-

module Activity
  class Base < ActiveRecord::Base
    self.abstract_class = true

    # def uses_db?
    #   true
    # end

    establish_connection "activity_#{Rails.env}".to_sym
  end
end