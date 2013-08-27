#encoding: utf-8

module NexusBase
  extend ActiveSupport::Concern

  def self.included base
    base.class_eval do
      establish_connection "nexus_#{Rails.env}".to_sym
    end
  end

end