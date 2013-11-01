#coding: utf-8

class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :code,length: 8
      t.string :name
      t.string :category,length:  8
      t.string :plan_category,length: 12
      t.string :times,length: 18
      t.string :value
      t.decimal :price,precision: 10, scale: 2

      t.timestamps
    end
    
    h = []
    h << {id:  0,name: '试用'}
    h << {id:  1,name: '一年基础包'}
    h << {id:  0,name: '两年基础包'}
    h
    
    Package.create code: '1001',name: '试用',category: 'basic',value: 'personal:0,custom:0',times: '1.month'
    Package.create code: '1002',name: '一年基础包',category: 'basic',value: 'personal:50000,custom:4000',times: '1.year'
    Package.create code: '1003',name: '两年基础包',category: 'basic',value: 'personal:100000,custom:8000',times: '2.years'
    Package.create code: '2001',name: '个性化筛选短信',category: 'added',plan_category: 'personal',price: 0.07
    Package.create code: '2002',name: '自定义名单短信',category: 'added',plan_category: 'custom',price: 0.10
  end
end
