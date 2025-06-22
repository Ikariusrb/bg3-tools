# frozen_string_literal: true

module Scrapeable
  extend ActiveSupport::Concern

  included do |base|
    unless base.const_defined?('UNIQUE_COLUMNS') || base.column_names.include?('name')
      raise NameError, "either UNIQUE_COLUMNS or a column named 'name' must be defined in #{self.class.name}"
    end
  end

  class_methods do
    def new_from_scrape(...)
      scraped = "Scraper::#{name}".constantize.new(...).call
      new(**scraped.to_h)
    end

    def upsert_from_scrape(...)
      scraped = "Scraper::#{name}".constantize.new(...).call
      check_blank_column = self::UNIQUE_COLUMNS.first || :name
      return if scraped.public_send(check_blank_column).blank?
      upsert(scraped.to_h, unique_by: (self::UNIQUE_COLUMNS || [ :name ]))
    end
  end
end
