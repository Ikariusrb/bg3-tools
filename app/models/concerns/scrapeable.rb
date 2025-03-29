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
    end
end
