class CreateTableTags < ActiveRecord::Migration
  def change
    create_table  :tags do |t|
      t.string    :tag_name
      t.integer   :tag_code, limit: 8
    end
    add_index :tags,  :tag_name
  end
end

