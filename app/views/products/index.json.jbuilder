json.array!(@products) do |product|
  json.extract! product, :id, :description, :unit, :unit_price
  json.url product_url(product, format: :json)
end
