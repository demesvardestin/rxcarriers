json.extract! request_message, :id, :created_at, :updated_at
json.url request_message_url(request_message, format: :json)
