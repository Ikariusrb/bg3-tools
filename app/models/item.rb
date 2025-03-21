# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  description :string
#  name        :string
#  uuid        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Item < ApplicationRecord
end
