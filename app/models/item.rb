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
class Item < ApplicationRecord
end
