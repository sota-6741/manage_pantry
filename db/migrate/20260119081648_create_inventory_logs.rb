class CreateInventoryLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_logs do |t|
      t.references :item, null: false, foreign_key: true
      t.decimal :change_amount
      t.integer :reason

      t.timestamps
    end
  end
end
