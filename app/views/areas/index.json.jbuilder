json.array!(@areas) do |area|
  json.extract! area, :id, :title, :alias
  json.url area_url(area, format: :json)
end
