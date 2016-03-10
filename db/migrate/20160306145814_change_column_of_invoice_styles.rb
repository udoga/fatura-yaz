class ChangeColumnOfInvoiceStyles < ActiveRecord::Migration
  def change
    remove_column :invoice_styles, :style_file, :string
    add_column :invoice_styles, :style_content, :text
  end
end
