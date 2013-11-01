class CreateMpGroupCities < ActiveRecord::Migration
  def change
    create_table :group_cities do |t|
      t.string :name
      t.string :pinyin
      t.string :code
      t.boolean :active,default: false

      t.timestamps
    end
  end
end
