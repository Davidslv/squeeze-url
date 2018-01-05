ENV['RACK_ENV'] = 'test'

require 'spec_helper'
require 'rack/test'
require './app'

RSpec.describe Application do
  include Rack::Test::Methods

  def app
    Application
  end

  context "POST /" do
    context 'when a valid request is made' do
      it "should not 404" do
        post "/", { "url" => "helloworld.com" }.to_json
        expect(last_response.ok?).to be true
      end

      it 'returns JSON response with url and short url' do
        post "/", { "url" => "helloworld.com" }.to_json
        body = JSON.parse last_response.body

        expect(body["url"]).to eql("helloworld.com")

        expect(body.has_key?("url")).to be true
        expect(body.has_key?("short_url")).to be true
      end

      it 'returns the same short url for the same url' do
        post "/", { "url" => "helloworld.com" }.to_json
        first_request_body = JSON.parse last_response.body

        post "/", { "url" => "helloworld.com" }.to_json

        second_request_body = JSON.parse last_response.body

        expect(
          first_request_body["short_url"]
        ).to eql(second_request_body["short_url"])
      end
    end

    context 'when an invalid request is made' do
      it "should not 404" do
        expect {
          post "/", { "url" => "com" }.to_json
        }.to raise_error(RequestError, "Invalid URL has been provided: http://com")
      end
    end
  end

  context "GET /:short_url" do
    context 'when a url has been stored' do
      before do
        post "/", { "url" => "helloworld.com" }.to_json
      end

      it 'returns the url' do
        short_url = JSON.parse(last_response.body)["short_url"]

        get "/#{short_url}"

        body = JSON.parse(last_response.body)
        expect(body["url"]).to eql("http://helloworld.com")
      end

      it 'returns status 301' do
        short_url = JSON.parse(last_response.body)["short_url"]

        get "/#{short_url}"

        expect(last_response.status).to eql(301)
      end
    end

    context 'when an invalid request is made' do
      it "returns 404" do
        get "/random"

        expect(last_response.status).to eql(404)
      end
    end
  end
end
