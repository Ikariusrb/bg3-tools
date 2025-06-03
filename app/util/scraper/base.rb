# frozen_string_literal: true

class Scraper::Base
  CACHE_DURATION = 2.days

private

  def url
    raise NotImplementedError.new("Subclasses must implement the URL method")
  end

  def document
    @document ||= fetch_document(url)
  end

  def fetch_document(url)
    if defined?(ScrapeCache)
      ScrapeCache.fetch(url, expires_in: CACHE_DURATION, key_for: method(:url_key)) do
        scraper.get(url).body
      end.yield_self do |content|
        Nokogiri::HTML5.parse(content)
      end
    else
      content = scraper.get(url).body
      Nokogiri::HTML5.parse(content)
    end
  end

  def url_key(url)
    Digest::SHA2.hexdigest(url)
  end

  def scraper
    @scraper ||= Mechanize.new
  end
end
