class CreateTableIndicator < ActiveRecord::Migration
  def change
    create_table :_indicators do |t|
      t.string :category
      t.integer :num
      t.date  :the_day

      t.references :_marketings

      t.timestamps
    end
    add_index :_indicators,  :category
    add_index :_indicators,  :the_day
  end
end
