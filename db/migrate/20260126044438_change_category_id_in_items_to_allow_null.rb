class ChangeCategoryIdInItemsToAllowNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :items, :category_id, true
  end
end
