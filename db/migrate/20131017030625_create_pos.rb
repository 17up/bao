class CreatePos < ActiveRecord::Migration
  def change
    create_table :pos do |t|
      t.references :merchant, index: true
      t.references :store, index: true
      t.string :mid
      t.string :tid
      t.boolean :deleted,default: false
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
