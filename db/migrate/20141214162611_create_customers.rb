class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.text :address
      t.string :tax_office
      t.string :tax_office_no

      t.timestamps
    end
  end
end
