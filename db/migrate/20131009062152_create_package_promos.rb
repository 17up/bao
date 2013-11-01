class CreatePackagePromos < ActiveRecord::Migration
  def change
    create_table :package_promos do |t|
      t.references :package, index: true
      t.string :name
      t.integer :max
      t.integer :min
      t.decimal :price,precision: 10, scale: 2
      t.timestamp :begin_at
      t.timestamp :end_at

      t.timestamps
    end
  end
end
