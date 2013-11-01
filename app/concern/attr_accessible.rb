module AttrAccessible
  extend ActiveSupport::Concern

  included do
    attr_accessible *column_names.delete_if { |x| x.to_sym == :id }.map(&:to_sym)
  end

end