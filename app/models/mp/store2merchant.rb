class MP::Store2merchant < ActiveRecord::Base
  self.table_name = "_store2merchant"
  include AttrAccessible
end
