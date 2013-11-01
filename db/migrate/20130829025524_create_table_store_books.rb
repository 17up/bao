class CreateTableStoreBooks < ActiveRecord::Migration
  def change
    create_table  :store_books do |t|
      t.integer   :store_id
      t.datetime  :trans_rcv_ts
      t.date      :the_day
      t.integer   :the_hour, limit: 2
      t.float     :trans_amount
      t.string    :tid
      t.string    :card_no
      t.string    :trans_code
    end
    add_index :store_books,  :the_hour
    add_index :store_books,  :the_day
  end
end
