class Mp::Customer < ActiveRecord::Base
	self.table_name =  "shanghai_54_return_customer"

	def self.connect(key)
		if table = ActiveRecord::Base.connection.tables.grep(/#{key}/)[0]
			self.table_name = table
		end
	end
end
