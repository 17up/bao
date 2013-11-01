class CreateTableCardProps < ActiveRecord::Migration
  def change
    create_table  :card_props do |t|
      t.integer   :store_id
      t.date      :the_day
      t.string    :card_no
      t.integer   :tags, limit: 8
      t.integer   :ability
      t.integer   :intensity
      t.boolean   :is_new
      t.string    :card_level, limit: 1
      t.float     :gender
    end
    add_index :card_props,  :is_new
    add_index :card_props,  :the_day
  end
end
