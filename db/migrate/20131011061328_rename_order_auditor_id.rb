class RenameOrderAuditorId < ActiveRecord::Migration
  def change
    rename_column :orders,:auditor_id_id,:auditor_id
  end
end
