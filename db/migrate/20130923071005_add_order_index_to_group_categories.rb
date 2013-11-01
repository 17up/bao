class AddOrderIndexToGroupCategories < ActiveRecord::Migration
  def change
    add_column :group_categories, :order_index, :integer,default: 0
  end
end
