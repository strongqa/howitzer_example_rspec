require 'spyke'
require 'multi_json'

class JSONParser < Faraday::Response::Middleware
  def parse(body)
    json = MultiJson.load(body, symbolize_keys: true)
    return { data: json } if !json.is_a?(Hash) || json[:errors].blank?
    { data: json, errors: parse_errors_in_rails5_style(json) }
  rescue MultiJson::ParseError => exception
    { errors: { base: [ error: exception.message ] } }
  end

  private

  def parse_errors_in_rails5_style(json)
    json.fetch(:errors, {}).transform_values { |messages| messages.map {|msg|{ error: msg } } }
  end
end

class TestTokenAuthentication < Faraday::Middleware
  def call(env)
    if Howitzer.app_api_token.present?
      env[:request_headers]['Authorization'] = "Token token=#{Howitzer.app_api_token}"
    end
    @app.call(env)
  end
end

Spyke::Base.connection = Faraday.new(url: "#{Howitzer.app_uri.site}/#{Howitzer.app_api_end_point}") do |c|
  c.request   :json
  c.use       TestTokenAuthentication
  c.use       JSONParser
  c.adapter   Faraday.default_adapter
end
