class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :name
      t.decimal :quantity, precision: 8, scale: 2, default: 0, null: false
      t.string :unit
      t.date :expiration_date
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
