# frozen_string_literal: true

class ItemScraper
  attr_reader :item_name

  BASE_URL = 'https://bg3.wiki/wiki/'
  CACHE_DURATION = 2.days

  ItemStruct = Struct.new(
    :name, :description, :special_properties, :uuid, :location,
    :rarity, :type, :weight, :value, :image_url, :effects,
    keyword_init: true
  )

  def initialize(item_name)
    @item_name = item_name
  end

  def item_details
    ItemStruct.new(
      name: parsed_name,
      description: item_description,
      uuid: item_uuid,
      location: item_location,
      rarity: item_rarity,
      type: item_type,
      weight: item_weight,
      value: item_value,
      effects: item_effects,
    )
  end

  private

  def fetch_item_details
    # Extract data from the document
    name = parsed_name
    description = item_description
    uuid = item_uuid
    location = item_location
    type = item_type
    rarity = item_rarity
    weight = item_weight
    value = item_value
  end

  def parsed_name
    @item_name ||= document.root.xpath('//span[contains(@class,"mw-page-title-main")]').text.strip
  end

  def item_description
    @item_description ||= document.root
      .xpath('//div[contains(@class,"mw-parser-output")]').xpath('.//p').first.text.strip
  end

  def item_special_properties
    @item_special_properties ||= document.root
      .xpath('//div[contains(@class,"bg3wiki-property-list")]')
      .xpath('.//li')
      .map { |li| li.text.strip }
  end

  def item_effects
    @item_effects ||= document.root.xpath('//h3').find { |h| h.text.include?("Special") }.xpath('.//following-sibling::dl').text.strip
  end

  def item_uuid
    @item_uuid ||= item_special_properties.find { |prop| prop.include?("UUID") }.match(/UUID\W*([0-9,a-z,-]+)/)[1]
  end

  def item_location
    @item_location ||= document.root.xpath('//div[contains(@class,"bg3wiki-tooltip-box")]').last.xpath('.//li').text.strip
  end

  def item_rarity
    @item_rarity ||= item_special_properties.find { |prop| prop.start_with?("Rarity:") }.split.last
  end

  def item_type
    @item_type ||= item_special_properties.first
  end

  def item_weight
    @item_weight ||= item_special_properties.find { |prop| prop.start_with?("Weight:") }.split.last
  end

  def item_value
    @item_value ||= item_special_properties.find { |prop| prop.start_with?("Price:") }.delete_prefix("Price: ").strip
  end

  def extract_image_url
    img_element = document.css('.infobox-image img').first
    img_element ? img_element['src'] : nil
  end

  def document
    @document ||= fetch_document("#{BASE_URL}#{url}")
  end

  def url
    @url ||= item_name.titlecase.gsub(/ Of /, " of ").gsub(/ The /, " the ").gsub(' ', '_')
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
