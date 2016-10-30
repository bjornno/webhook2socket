require 'json'
require 'restclient'
require 'sinatra'
require "base64"

access_token = "NmYxNTBlZTYtZjU4ZS00MTU2LTlkNWUtNzc3MjQ3MjQ5MjJlNjUyYTJhNDQtMWI1"
bot_email = "kalle@sparkbot.io"

resource = RestClient::Resource.new(
    "https://api.ciscospark.com/v1/messages/",
    headers: { authorization: "Bearer #{access_token}", 'Content-Type' => 'application/json'},
    verify_ssl: OpenSSL::SSL::VERIFY_NONE
)

post '/spark-hook' do
  request.body.rewind
  body = JSON.parse(request.body.read, symbolize_names: true)
  room_id = body[:data][:roomId]
  if body[:data][:personEmail] != bot_email
    context = $contexts[body[:data][:personEmail].to_sym] || {id: body[:data][:personEmail].to_sym}
    message_body = resource[body[:data][:id]].get
    parsed_message_body = JSON.parse(message_body, symbolize_names: true)
  end
end
