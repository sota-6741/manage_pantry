class ChangeUniqueIndexOnCategoriesName < ActiveRecord::Migration[8.1]
  def change
    remove_index :categories, :name if index_exists?(:categories, :name)
    add_index :categories, [:name, :user_id], unique: true
  end
end
