# frozen_string_literal: true

# == Schema Information
#
# Table name: builds
#
#  id          :integer          not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_builds_on_name  (name) UNIQUE
#
class Build < ApplicationRecord
  has_many :build_items, dependent: :destroy
  has_many :items, through: :build_items
end
