class CreateTableMarketing < ActiveRecord::Migration
  def change
    create_table :_marketings do |t|
      t.integer :program_id
      t.string  :program_code
      t.integer :store_id
      t.string  :type

      t.timestamps
    end
    add_index :_marketings,  :store_id
    add_index :_marketings,  :program_id
  end
end
