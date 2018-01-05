require 'spec_helper'
require './lib/url_storage'

RSpec.describe UrlStorage do
  let(:url_storage) { described_class.new }
  let(:url) { "http://helloworld.com" }

  describe '#save' do
    context 'when a valid url is given' do
      it 'stores a url and returns the short_url string value' do
        expect(
          url_storage.save(url)
        ).to be_a(String)
      end

      it 'returns the same short_url string value for the same url' do
        first_short_url = url_storage.save(url)

        expect(
          url_storage.save(url)
        ).to eql(first_short_url)
      end
    end

    context 'when a url is given without a schema' do
      it 'stores the url with the "http" schema' do
        short_url = url_storage.save("helloworld.com")

        expect(
          url_storage.read(short_url)
        ).to eql("http://helloworld.com")
      end
    end

    context 'when a url is invalid' do
      it 'should raise a RequestError' do
        expect {
          url_storage.save("helloworld")
        }.to raise_error(RequestError, "Invalid URL has been provided: http://helloworld")
      end
    end
  end

  describe '#read' do
    context 'when a short url does not exist' do
      it 'returns nil' do
        expect(
          url_storage.read("random")
        ).to be nil
      end
    end

    context 'when a url has been saved previously' do
      it 'returns a url of a given short_url' do
        first_short_url = url_storage.save(url)

        expect(
          url_storage.read(first_short_url)
        ).to eql(url)
      end
    end
  end
end
