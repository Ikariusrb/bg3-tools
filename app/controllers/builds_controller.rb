class BuildsController < ResourceController
  RESOURCE = "build".freeze
  INDEX_COLUMNS = %w[name description].freeze
  PERMIT_ATTRIBUTES = %i[name description].freeze
end
