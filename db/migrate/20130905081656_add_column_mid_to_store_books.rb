class AddColumnMidToStoreBooks < ActiveRecord::Migration
  def change
    add_column :store_books, :mid, :string
  end
end
