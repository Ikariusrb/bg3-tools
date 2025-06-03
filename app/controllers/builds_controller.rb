# frozen_string_literal: true

class BuildsController < ResourceController
  RESOURCE = "build"
  INDEX_COLUMNS = %w[name description].freeze
  PERMIT_ATTRIBUTES = %i[name description].freeze
end
