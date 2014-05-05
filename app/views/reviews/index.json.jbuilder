json.array!(@reviews) do |review|
  json.extract! review, :id, :author, :text
  json.url review_url(review, format: :json)
end
