class ChangeReasonTypeInInventoryLogs < ActiveRecord::Migration[8.1]
  def change
    change_column :inventory_logs, :reason, :string, null: false
  end
end