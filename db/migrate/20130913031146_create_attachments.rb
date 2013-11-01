class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :merchant, index: true
      t.references :store, index: true
      t.references :user, index: true
      t.integer :ref_id
      t.string :ref_clazz
      t.string :ref_url
      t.string :file
      t.string :atta_path
      t.string :atta_type
      t.integer :atta_size
      t.string :atta_name
      t.boolean :deleted
      t.timestamp :deleted_at
      t.string :remark
      t.string :token

      t.timestamps
    end
  end
end
