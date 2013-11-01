class CreateNameLists < ActiveRecord::Migration
  def change
    create_table :name_lists do |t|
      t.string :name
      t.references :user, index: true
      t.references :merchant, index: true
      t.references :store, index: true
      t.integer :count

      t.timestamps
    end
  end
end
