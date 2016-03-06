class CreateInvoiceStyles < ActiveRecord::Migration
  def change
    create_table :invoice_styles do |t|
      t.string :name
      t.string :style_file

      t.timestamps
    end
  end
end
