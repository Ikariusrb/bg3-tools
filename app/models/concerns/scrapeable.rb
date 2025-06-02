# frozen_string_literal: true

module Scrapeable
  extend ActiveSupport::Concern

  included do
    # Code to run when the module is included in a class
  end

  class_methods do
    def new_from_scrape(...)
      scraped = "Scraper::#{name}".constantize.new(...).call
      self.new(**scraped.to_h)
    end

    def upsert_from_scrape(...)
      scraped = "Scraper::#{name}".constantize.new(...).call
      check_blank_column = self::UNIQUE_COLUMNS.first || :name
      return if scraped.public_send(check_blank_column).blank?
      self.upsert(scraped.to_h, unique_by: (self::UNIQUE_COLUMNS || [ :name ]))
    end
  end
end
