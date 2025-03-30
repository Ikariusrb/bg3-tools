class ItemsController < ResourceController
  RESOURCE = "item".freeze
  INDEX_COLUMNS = %w[name description uuid].freeze
  PERMIT_ATTRIBUTES = %i[name description item_type location act rarity uuid weight price effects].freeze
end
