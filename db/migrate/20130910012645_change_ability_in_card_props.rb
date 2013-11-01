class ChangeAbilityInCardProps < ActiveRecord::Migration
  def up
    change_column :card_props, :ability, :float, default: 0
  end

  def down
    change_column :card_props, :ability, :integer
  end
end
