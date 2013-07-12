require 'uri'

class Params
  def initialize(req, route_params)
    body = URI::decode_www_form(req.body.to_s)
    query = URI::decode_www_form(req.query_string.to_s)
    @params = parse_www_encoded_form(body)
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  #private
  def parse_www_encoded_form(www_encoded_form)
    www_encoded_form.map! { |elem| parse_key(elem.first, elem.last)}
    www_encoded_form.inject { |one, two| one = deep_merge(one, two) }
  end

  def deep_merge(one, two)
    return one unless two.is_a?(Hash)
    return two unless one.is_a?(Hash)
    a, b = one.keys, two.keys.first
    a.include?(b) ? one.merge!({b => deep_merge(one[b], two[b])}) : one.merge!(two)
  end

  def parse_key(key, value)
    r = /(?<head>.*?)\[(?<middle>.*?)\](?<rest>.*)/.match(key)
    return {r[:head] => value} if r[:middle].empty?
    return {r[:head] => {r[:middle] => value}} if r[:rest].empty?
    {r[:head] => parse_key(r[:middle] + r[:rest])}
  end

end

# def parse_key(key)
#   r = /(?<head>.*?)\[(?<middle>.*?)\](?<rest>.*)/.match(key)
#   return [r[:head]] if r[:middle].empty?
#   return [r[:head], r[:middle]] if r[:rest].empty?
#   [r[:head]] + parse_key(r[:middle] + r[:rest])
# end

# a = parse_key("cats[name][value][third]")
# b = parse_key("cats[name][inner][value]")
# final_hash = {}

# def nest_hash(array, value)
#   return value if array.empty?
#   {array.first => nest_hash(array.drop(1), value)}
# end

# one = nest_hash(a, 1)
# two = nest_hash(b, 1)