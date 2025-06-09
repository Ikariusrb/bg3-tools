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
require 'rails_helper'

RSpec.describe Build, type: :model do
  let(:build) { FactoryBot.build(:build) }
  subject { build }
  describe 'associations' do
    it { should have_many(:build_items).dependent(:destroy) }

    it { should have_many(:items).through(:build_items) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:name) }
  end

  describe 'basic functionality' do
    let(:build) { FactoryBot.create(:build) }
    let(:item1) { FactoryBot.create(:item) }
    let(:item2) { FactoryBot.create(:item) }

    it 'can add items to the build' do
      expect {
        FactoryBot.create(:build_item, build: build, item: item1)
        FactoryBot.create(:build_item, build: build, item: item2)
      }.to change { build.items.count }.by(2)

      expect(build.items).to include(item1)
      expect(build.items).to include(item2)
    end

    it 'removes build_items but not items when build is destroyed' do
      build_item1 = FactoryBot.create(:build_item, build: build, item: item1)
      build_item2 = FactoryBot.create(:build_item, build: build, item: item2)

      expect {
        build.destroy
      }.to change { BuildItem.count }.by(-2)

      expect(BuildItem.exists?(build_item1.id)).to be_falsey
      expect(BuildItem.exists?(build_item2.id)).to be_falsey
      # The items themselves should still exist
      expect(Item.exists?(item1.id)).to be_truthy
      expect(Item.exists?(item2.id)).to be_truthy
    end
  end
end
