class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.text :description
      t.string :unit
      t.decimal :unit_price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
