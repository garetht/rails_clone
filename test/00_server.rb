require 'active_support/core_ext'
require 'webrick'
require 'rails_lite'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class MyController < ControllerBase
  def go
    render_content("hello world!", "text/html")

    render :show

   session["count"] ||= 0
   session["count"] += 1
   render :counting_show
  end
end

server.mount_proc('/') do |request, response|
  response.body = request.path
  response['Content-Type'] = 'text/text'
  MyController.new(request, response).go
end

server.start
