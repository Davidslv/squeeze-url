require 'securerandom'

class UrlStorage
  def initialize
    @store = {}
    @store_reversed = {}
  end

  def save(url)
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
end
