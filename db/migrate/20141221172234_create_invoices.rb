class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.date :date
      t.time :time
      t.float :tax_rate
      t.references :customer

      t.timestamps
    end
  end
end
