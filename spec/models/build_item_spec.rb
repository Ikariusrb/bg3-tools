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
require 'rails_helper'

RSpec.describe BuildItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
