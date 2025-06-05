# frozen_string_literal: true

class BuildItemsController < SubResourceController
  RESOURCE = "build_item"
  PARENT_RESOURCE = "build"
  PERMIT_ATTRIBUTES = [ :build_id, :item_id ].freeze
end
