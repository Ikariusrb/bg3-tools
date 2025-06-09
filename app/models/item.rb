# frozen_string_literal: true

# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  act         :string
#  description :string
#  effects     :string
#  item_type   :string
#  location    :string
#  name        :string
#  price       :string
#  rarity      :string
#  uuid        :string
#  weight      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_items_on_name  (name) UNIQUE
#
class Item < ApplicationRecord
  include Scrapeable

  UNIQUE_COLUMNS = %i[name].freeze

  NO_SUBFORM_RELATIONS = %w[build_items].freeze

  ITEM_TYPE_VALUES = %i[
    boots rings gloves helmets amulets shields cloaks clothing lightarmor mediumarmor
    longswords maces scimitars tridents shortswords daggers spears warhammers battleaxes
    greatswords javelins pikes lighthammers clubs
  ].freeze

  has_many :build_items, dependent: :restrict_with_exception
  has_many :builds, through: :build_items

  enum :item_type, ITEM_TYPE_VALUES.zip(ITEM_TYPE_VALUES.map(&:to_s)).to_h, validate: true

  validates :name, uniqueness: true
end
