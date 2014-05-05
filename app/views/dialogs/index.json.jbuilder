json.array!(@dialogs) do |dialog|
  json.extract! dialog, :id, :ip, :coordinates, :city
  json.url dialog_url(dialog, format: :json)
end
