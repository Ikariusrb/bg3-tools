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
require 'rails_helper'

RSpec.describe Build, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
