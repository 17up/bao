# coding: utf-8
require 'yaml'

module Properties
  attr_accessor :properties

  def load property_file
    self.properties = YAML.load File.readlines(property_file).join("\n").gsub("=", ": ")
  end

  def get key
    self.properties[key.to_s]
  end

  alias load_properties load
  alias get_property get
end