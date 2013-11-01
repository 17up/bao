#encoding: utf-8

class CreateMerchantCategories < ActiveRecord::Migration
  def change
    create_table :merchant_categories do |t|
      t.references :parent, index: true
      t.string :name
      t.timestamp :deleted_at
      t.boolean :deleted,default: false

      t.timestamps
    end
    
json_str =<<__json__
{
	"mch_cate":
	[
		{
			"c1":"美食餐饮",
			"c2":[
				"快餐小吃",
			 	"江浙菜",
				"北京菜",      
				"甜点饮品",   
				"川菜",        
				"火锅烧烤",    
				"日韩料理",    
				"西餐",      
				"粤港菜",   
				"湘菜",       
				"清真菜",      
				"东北菜",      
				"台湾菜",     
				"自助餐",      
				"海鲜",        
				"湖北菜",      
				"鲁菜",       
				"西北菜",      
				"云南菜",      
				"贵州菜",      
				"山西菜",      
				"江西菜",      
				"蒙古菜",      
				"陕西菜",      
				"闽南菜",      
				"徽菜",   
				"东南亚菜",   
				"特色餐厅",   
				"茶餐厅",      
				"素菜",       
			 	"其他"        
			]
		},
		{
			"c1":"休闲娱乐",
			"c2":[
				 "咖啡厅" ,       
				 "养生按摩",      
				 "景点郊游",     
				 "文化艺术",      
				"温泉洗浴",      
				 "酒吧" ,         
				" KTV" ,          
				 "茶馆/茶室" ,   
				 "台球厅"  ,      
				 "网吧/电玩",     
				 "运动健身",      
				 "电影院" ,       
				 "桌面游戏",      
				 "其他"          
			]
		},
		{
			"c1":"百货购物",
			"c2":[
				 "商场" ,        
				 "超市"  ,       
				 "便利店" ,      
				 "建材市场" ,    
				 "眼镜店" ,      
				 "其他"         
			]
		},
		{
			"c1":"美容丽人",
			"c2":[
				 "美发 " ,       
				 "美容/SPA" ,    
				 "美甲 "  ,      
				 "瘦身纤体  "  , 
				 "瑜伽"    ,     
				 "舞蹈"  ,       
				 "整形 "  ,      
				" 其他"         
			]
		},
		{
			"c1":"生活服务",
			"c2":[
				 "摄影写真"  ,   
				 "教育培训" ,    
				 "装饰装修"  ,   
				 "宠物 "  ,      
				" 健康护理" ,    
				 "汽车"    ,     
				" 婚庆服务" ,    
				 "其他  "       
			]
		},
		{
			"c1":"旅游酒店",
			"c2":[
				" 经济型酒店"  ,  
				"二星级酒店" ,
				"三星级酒店" , 
				"四星级酒店"  ,
				"五星级酒店  ",
				" 其他 "     
			]
		}
	]
}
__json__

    JSON.parse(json_str)['mch_cate'].each do |category|
     parent = MerchantCategory.create name: category['c1'].gsub(' ','')
     category['c2'].each do |child_category|
       MerchantCategory.create name: child_category.gsub(' ',''),parent_id: parent.id
     end
    end
    
  end
end