require 'json'
require 'sinatra/base'
require_relative 'lib/url_storage'

class Application < Sinatra::Application
  def initialize
    @url_storage = UrlStorage.new
    super
  end

  set :port, 4000

  post '/' do
    payload = JSON.parse(request.body.read)
    url = payload["url"]
    short_url = @url_storage.save(url)

    {"short_url" => short_url, "url" => url}.to_json
  end

  get '/:short_url' do
    short_url = params["short_url"]
    url = @url_storage.read(short_url)

    halt(404) unless url

    redirect(url, 301, { "url" => url }.to_json)
  end
end

Application.run! unless ENV['RACK_ENV'] == "test"
