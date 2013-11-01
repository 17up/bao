class ChangeColumnGenderDefaultValue < ActiveRecord::Migration
  def up
    change_column :card_props, :gender, :float, default: 0.5
  end

  def down
    change_column :card_props, :gender, :float
  end
end
