module Util
  class Mobiles
    # @root_dir = '/home/hduser/ups_cm/city_data'
    def execute
      @root_dir = '/Users/martin/Data/imc/city'

      Dir.entries(@root_dir).each do |dir|
        #Mp::Mobile.update_table_name dir

        file = "#{@root_dir}/#{dir}/feature/f7_usr_consistency"
        next unless File.exist?(file)

        mobiles = []

        IO.readlines(file).each do |l|
          if l =~ /(.*?)`(.*?)\t.*/
            mobiles<< Mp::Mobile.new(mobile: $2, customer_type: $1=~/\d+/ ? 0 : 1)
          end
        end


        Mp::Mobile.import mobiles, :validate => false
      end
    end #execute
  end #mobiles
end #util