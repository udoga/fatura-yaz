json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :date, :time, :tax_rate
  json.url invoice_url(invoice, format: :json)
end
