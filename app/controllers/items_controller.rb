class ItemsController < ResourceController
  RESOURCE = "item".freeze
  INDEX_COLUMNS = %w[name description uuid].freeze
  PERMIT_ATTRIBUTES = %i[name description uuid].freeze
end
