json.array!(@products) do |product|
  json.extract! product, :id, :image, :title, :desc, :price, :weight, :avail
  json.url product_url(product, format: :json)
end
