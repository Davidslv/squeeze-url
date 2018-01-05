require 'uri'
require 'securerandom'

class RequestError < StandardError; end

class UrlStorage
  def initialize
    @store = {}
    @store_reversed = {}
  end

  def save(url)
    url = format_url(url)
    validate(url)

    return store[url] if store[url]
    short_url = SecureRandom.urlsafe_base64[0..5]
    store_reversed[short_url] ||= url
    store[url] ||= short_url
  end

  def read(short_url)
    store_reversed[short_url]
  end

  private
    attr_reader :store, :store_reversed

  def format_url(url)
    uri = URI.parse(url)

    if uri.scheme.nil? && uri.host.nil? && !uri.path.nil?
      uri.scheme = "http"
      uri.host = uri.path
      uri.path = ""
    end

    uri.to_s
  end

  def validate(url)
    tld = url.split('.')

    # naive approach, assuming that a URL with no dot does not have a TLD
    # it seems the URI.regexp doesn't account for that case.
    if (url =~ URI.regexp).nil? || tld.size == 1
      raise RequestError, "Invalid URL has been provided: #{url}"
    end
  end
end
