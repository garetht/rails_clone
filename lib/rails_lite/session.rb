require 'json'
require 'webrick'

class Session
  def initialize(req)
    @session_hash = {}
    session_cookie = nil
    req.cookies.each do |cookie|
      session_cookie = cookie if cookie.name == "_rails_lite_app"
    end
    @session_hash["cookie"] = JSON.parse(session_cookie.value) if session_cookie
  end

  def [](key)
    @session_hash[key]
  end

  def []=(key, val)
    @session_hash[key] = val
  end

  def store_session(res)
    new_cookie = WEBrick::Cookie.new("_rails_lite_app", JSON.dump(@session_hash))
    res.cookies << new_cookie
  end
end
