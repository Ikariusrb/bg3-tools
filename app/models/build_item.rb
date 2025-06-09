# frozen_string_literal: true

# == Schema Information
#
# Table name: build_items
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  build_id   :integer          not null
#  item_id    :integer          not null
#
# Indexes
#
#  index_build_items_on_build_id              (build_id)
#  index_build_items_on_item_id               (item_id)
#  index_build_items_on_item_id_and_build_id  (item_id,build_id) UNIQUE
#
# Foreign Keys
#
#  build_id  (build_id => builds.id)
#  item_id   (item_id => items.id)
#
class BuildItem < ApplicationRecord
  belongs_to :build
  belongs_to :item

  validates :item, uniqueness: { scope: :build_id, message: 'item is already linked to this build' }
end
