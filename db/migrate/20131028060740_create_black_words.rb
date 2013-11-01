class CreateBlackWords < ActiveRecord::Migration
  def change
    create_table :black_words do |t|
      t.string :name
      t.boolean :active,default: true
      t.boolean :deleted,default: false
      t.timestamp :deleted_at

      t.timestamps
    end
  end
end
