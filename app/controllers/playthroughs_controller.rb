# frozen_string_literal: true

class PlaythroughsController < ResourceController
  RESOURCE = "playthrough"
  INDEX_COLUMNS = %w[name description].freeze
  PERMIT_ATTRIBUTES = %i[name description].freeze
  NO_SUBFORM_RELATIONS = %w[playthrough_builds].freeze
end
