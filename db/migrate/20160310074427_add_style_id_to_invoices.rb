class AddStyleIdToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_style_id, :integer
    add_index :invoices, :invoice_style_id
  end
end
