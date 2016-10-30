require 'faye/websocket'
require 'sinatra'

Faye::WebSocket.load_adapter('thin')

get '/' do
  if Faye::WebSocket.websocket?(request.env)
    ws = Faye::WebSocket.new(request.env)

    ws.on(:open) do |event|
      puts 'On Open'
    end

    ws.on(:message) do |msg|
      ws.send(msg.data.reverse)  # Reverse and reply
    end

    ws.on(:close) do |event|
      puts 'On Close'
    end

    ws.rack_response
  else
    # Normal HTTP request
    [200, {'Content-Type' => 'text/plain'}, ['Hello']]
  end
end
