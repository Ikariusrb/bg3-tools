# frozen_string_literal: true

class Scraper::Item < Scraper::Base
  # This class scrapes item data from the BG3 wiki.
  # It retrieves various properties of an item based on its name.
  # The properties include name, description, UUID, location, act, rarity, type, weight, price, and effects.

  # @param search_name [String] The name of the item to search for.
  # @return [ItemStruct] A struct containing the item's properties.

  # Example usage:
  # scraper = Scraper::Item.new("Some Item Name")
  # item_data = scraper.call
  # puts item_data.name
  attr_reader :search_name

  BASE_URL = 'https://bg3.wiki/wiki/'

  ItemStruct = Struct.new(
    :name, :description, :uuid, :location, :act,
    :rarity, :item_type, :weight, :price, :effects,
    keyword_init: true
  )

  def initialize(search_name)
    @search_name = search_name
  end

  def call
    ItemStruct.new(
      name: item_name,
      description: item_description,
      uuid: item_uuid,
      location: item_location,
      act: item_act,
      rarity: item_rarity,
      item_type: item_type,
      weight: item_weight,
      price: item_price,
      effects: item_effects,
    )
  rescue => e
    Rails.logger.error("Error scraping item data for #{search_name}: #{e.message}")
    ItemStruct.new
  end

  private

  def item_name
    @item_name ||= document.root.xpath('//span[contains(@class,"mw-page-title-main")]').text.strip
  end

  def item_description
    @item_description ||= document.root
      .xpath('//div[contains(@class,"mw-parser-output")]').xpath('.//p').first.text.strip
  end

  def item_special_properties
    @item_special_properties ||= begin
      li_version = document.root
        .xpath('//div[contains(@class,"bg3wiki-property-list")]')
        .xpath('.//li')
      dl_version = document.root
        .xpath('//div[contains(@class,"bg3wiki-property-list")]')
        .xpath('.//dl')
        .xpath('.//dd')
      if li_version.present?
        li_version.map { |li| li.text.strip }
      elsif dl_version.present?
        dl_version.map { |dd| dd.children.map { |c2| c2.text.strip }.join }
      else
        []
      end
    end
  end

  def item_uuid
    @item_uuid ||= item_special_properties.find { |prop| prop.include?("UUID") }.match(/UUID\W*([0-9,a-z,-]+)/)[1]
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

  def item_price
    @item_price ||= item_special_properties.find { |prop| prop.start_with?("Price:") }.delete_prefix("Price: ").strip
  end

  def item_effects
    @item_effects ||= begin
      foo = document.root.xpath('//h3').find { |h| h.text.include?("Special") }
      if foo.xpath('.//following-sibling::dl').empty?
        foo.xpath('.//following-sibling::ul')
          .children.to_a
          .map { |node| (node.node_name == 'dt') ? node.text.strip + ": " : node.text.strip + "\n" }
          .join
          .chomp
      else
        foo.xpath('.//following-sibling::dl')
          .children.to_a
          .map { |node| (node.node_name == 'dt') ? node.text.strip + ": " : node.text.strip + "\n" }
          .join
          .chomp
      end
    end
  end

  def item_location
    @item_location ||= document.root
      .xpath('//h2')
      .find { |h| h.children.first.get_attribute(:id) == "Where_to_find" }
      .xpath('.//following-sibling::div[contains(@class,"bg3wiki-tooltip-box")]')
      .text.strip
  end

  def item_act
    @item_act ||= item_location.match(/([Aa]ct\s+\w+)/).to_s
  end

  def item_image_url
    img_element = document.css('.infobox-image img').first
    img_element ? img_element['src'] : nil
  end

  def url
    @url ||= BASE_URL + search_name.titlecase.gsub(' Of ', " of ").gsub(' The ', " the ").gsub(' ', '_')
  end
end
