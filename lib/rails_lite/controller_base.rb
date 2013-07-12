require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(request, response, route_params=nil)
    @request, @response = request, response
    @route_params = route_params
    @params = Params.new(@request, route_params)
  end

  def session
    @session ||= Session.new(@request)
  end

  def already_rendered?
    @already_rendered || @response_built
  end

  def redirect_to(url)
    @response.status = 302
    @response['Location'] = url
    @response_built = true
    session.store_session(@response)
  end

  def render_content(content, type)
    @response['Content-Type'] = type
    @response.body = content
    @already_rendered = true
    session.store_session(@response)
  end

  def render(action_name)
    controller_name = self.class.name.underscore
    erb = File.read("views/#{controller_name}/#{action_name}.html.erb")
    erb = ERB.new(erb).result(binding)
    render_content(erb, 'text/html')
  end

  def invoke_action(name)
  end
end
