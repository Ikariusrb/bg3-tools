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

  has_many :build_items
  has_many :builds, through: :build_items

  enum :item_type, [
    :boots, :rings, :gloves, :helmets, :amulets, :shields, :cloaks, :clothing, :lightarmor, :mediumarmor,
    :longswords, :maces, :scimitars, :tridents, :shortswords, :daggers, :spears, :warhammers, :battleaxes,
    :greatswords, :javelins, :pikes, :lighthammers, :clubs
  ]
end
