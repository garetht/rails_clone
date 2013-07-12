require 'webrick'

server = WEBrick::HTTPServer.new(:Port => 8080)


server.mount_proc '/' do |request, response|
  response.body = request.path
  response['Content-Type'] = 'text/text'
end

trap('INT') { server.shutdown }

server.start