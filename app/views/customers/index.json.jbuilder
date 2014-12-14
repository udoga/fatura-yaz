json.array!(@customers) do |customer|
  json.extract! customer, :id, :name, :address, :tax_office, :tax_office_no
  json.url customer_url(customer, format: :json)
end
