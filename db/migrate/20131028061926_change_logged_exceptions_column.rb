class ChangeLoggedExceptionsColumn < ActiveRecord::Migration
  def change
    change_column :logged_exceptions,:environment,:text, limit: 4294967295
  end
end
