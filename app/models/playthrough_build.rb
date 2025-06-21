# frozen_string_literal: true

# == Schema Information
#
# Table name: playthrough_builds
#
#  id             :integer          not null, primary key
#  companion      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  build_id       :integer
#  playthrough_id :integer          not null
#
# Indexes
#
#  index_playthrough_builds_on_build_id        (build_id)
#  index_playthrough_builds_on_playthrough_id  (playthrough_id)
#
# Foreign Keys
#
#  build_id        (build_id => builds.id)
#  playthrough_id  (playthrough_id => playthroughs.id)
#
class PlaythroughBuild < ApplicationRecord
  belongs_to :playthrough
  belongs_to :build, optional: true

  validates_uniqueness_of :companion, scope: :playthrough_id, message: 'already exists in this playthrough'
end
