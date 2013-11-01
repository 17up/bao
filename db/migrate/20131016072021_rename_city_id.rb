class RenameCityId < ActiveRecord::Migration
  def change
    rename_column '_city_info',:ID,:id
  end
end
