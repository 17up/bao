class CreateMpGroupCategories < ActiveRecord::Migration
  def change
    create_table :group_categories do |t|
      t.string :name
      t.integer :mtc_id
      t.integer :mcc_id
      t.integer :parent_id

      t.timestamps
    end
  end
end
