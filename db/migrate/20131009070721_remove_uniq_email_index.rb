class RemoveUniqEmailIndex < ActiveRecord::Migration
  def change
    # remove_index :members,:email
    begin
      execute "drop index index_members_on_email on members"
    rescue => e
      puts "\tcan't drop index:index_members_on_email"
    end
    add_index    :members,:email
    
    execute "update members set freezed=0"
  end
end
