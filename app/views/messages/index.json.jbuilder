json.array!(@messages) do |message|
  json.extract! message, :id, :author, :text, :k
  json.url message_url(message, format: :json)
end
