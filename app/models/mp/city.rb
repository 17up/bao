class Mp::City < ActiveRecord::Base
	self.table_name = "_city_info"
	attr_accessible :ID, :city_ch_name, :city_name, :city_class, :up_city, :up_province,:status

	scope :province, -> {where(:city_class => 1)}
	scope :active, -> {where(:status => 1)}

	def as_json
		super(only: [:city_ch_name]).merge(city_name: city_name.split(" ")[0].downcase)
	end

end
