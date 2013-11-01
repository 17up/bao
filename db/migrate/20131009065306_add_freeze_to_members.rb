class AddFreezeToMembers < ActiveRecord::Migration
  def change
    add_column :members, :freezed, :boolean,default: false
  end
end
