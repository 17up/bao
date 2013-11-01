class CreateNameMobiles < ActiveRecord::Migration
  def change
    create_table :name_mobiles do |t|
      t.references :name_list, index: true
      t.string :mobile

      t.timestamps
    end
  end
end
