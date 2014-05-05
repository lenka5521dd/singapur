json.array!(@users) do |user|
  json.extract! user, :id, :admin
  json.url user_url(user, format: :json)
end
