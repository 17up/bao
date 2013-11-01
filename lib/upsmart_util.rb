#encoding: utf-8

class UpsmartUtil
    def import_mobiles
      @root_dir = '/Users/martin/Data/imc/city'

      Dir.entries(@root_dir).each do |dir|
        #Mp::Mobile.update_table_name dir

        file = "#{@root_dir}/#{dir}/feature/f7_usr_consistency"
        next unless File.exist?(file)

        mobiles = []
        i = 0
        IO.readlines(file).each do |l|
          i+= 1
          if l =~ /(.*?)`(.*?)\t.*/            
            mobiles<< Mp::Mobile.new(mobile: "#{$2}", customer_type: ($1=~/\d+/ ? 0 : 1))
          end
                  #   
          if i>1000
            puts "save mobiles"
            Mp::Mobile.import mobiles
            mobiles = []
            i = 0
          end
        end        
      end
    end #execute
    
    def import_mtc
      Mp::GroupCategory.delete_all
      
      IO.readlines('./doc/mtc-mcc-mapping.csv').each do |line|
        mcc_id,mcc_name,mtc_id,mtc_name,others = line.split(',')
        mtc = Mp::GroupCategory.find_by mtc_id: mtc_id
        mtc = Mp::GroupCategory.create name: mtc_name,mtc_id: mtc_id if mtc.nil?
        
        mcc = Mp::GroupCategory.find_by mcc_id: mcc_id
        mcc = Mp::GroupCategory.create name: mcc_name,mtc_id: mtc_id,mcc_id: mcc_id,parent_id: mtc.id
      end
      
      Mp::GroupCategory.where('parent_id is null and mtc_id=?',14).first.update_attributes order_index: -1
      Mp::GroupCategory.where('parent_id is null and mtc_id=?',15).first.update_attributes order_index: -2
      
    end
    
    def import_city
      Mp::GroupCity.delete_all
      Mp::GroupCity.create name: '北京',pinyin: 'beijing',code: '0010',active: true
      Mp::GroupCity.create name: '上海',pinyin: 'shanghai',code: '0021',active: true
      Mp::GroupCity.create name: '广州',pinyin: 'guangzhou',code: '0020',active: true
      Mp::GroupCity.create name: '深圳',pinyin: 'shenzhen',code: '0755',active: true
    end
end #util