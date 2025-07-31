# frozen_string_literal: true

# == Schema Information
#
# Table name: playthroughs
#
#  id          :integer          not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Playthrough < ApplicationRecord
  has_many :playthrough_builds, dependent: :destroy
  has_many :builds, through: :playthrough_builds

  after_create_commit do
    Companions.instance.each do |companion|
      playthrough_builds.create(companion: companion)
    end
  end

  # TODO: Check the existing playthrough_builds for the first available custom companion name
  # instead of inferring it from the count
  def add_custom_companion
    companion_name = "Custom ##{playthrough_builds.count + 1}"
    playthrough_builds.create(companion: companion_name)
  end
end
