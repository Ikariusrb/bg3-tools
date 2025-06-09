# frozen_string_literal: true

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
  let(:item) { FactoryBot.create(:item) }
  let(:build) { FactoryBot.create(:build) }
  let(:build_item) { FactoryBot.build(:build_item, build: build, item: item) }
  subject { build_item }

  describe 'associations' do
    it { should belong_to(:build) }
    it { should belong_to(:item) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(build_item).to be_valid
    end

    context 'when no build is associated' do
      let(:build) { nil }
      it 'requires a build to be associated' do
        expect(build_item).not_to be_valid
      end
    end

    context 'when no item is associated' do
      let(:item) { nil }
      it 'requires a build to be associated' do
        expect(build_item).not_to be_valid
      end
    end

    # it { should validate_uniqueness_of(:item).scoped_to(:build).ignoring_case_sensitivity.with_message('item is already linked to this build') }
    it { should validate_uniqueness_of(:item).scoped_to(:build_id).ignoring_case_sensitivity.with_message('item is already linked to this build') }
  end

  describe 'database constraints' do
    let(:build) { FactoryBot.create(:build) }
    let(:item) { FactoryBot.create(:item) }

    it 'allows the same item in different builds' do
      build1 = FactoryBot.create(:build)
      build2 = FactoryBot.create(:build)

      build_item1 = FactoryBot.create(:build_item, build: build1, item: item)
      build_item2 = FactoryBot.build(:build_item, build: build2, item: item)

      expect(build_item2).to be_valid
      expect { build_item2.save! }.not_to raise_error
    end

    it 'allows the same build with different items' do
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)

      build_item1 = FactoryBot.create(:build_item, build: build, item: item1)
      build_item2 = FactoryBot.build(:build_item, build: build, item: item2)

      expect(build_item2).to be_valid
      expect { build_item2.save! }.not_to raise_error
    end
  end

  describe 'relationships' do
    let(:build) { FactoryBot.create(:build, name: 'Test Build') }
    let(:item) { FactoryBot.create(:item, name: 'Test Item') }
    let!(:build_item) { FactoryBot.create(:build_item, build: build, item: item) }

    it 'maintains relationship with build' do
      expect(build_item.build).to eq(build)
      expect(build_item.build.name).to eq('Test Build')
    end

    it 'maintains relationship with item' do
      expect(build_item.item).to eq(item)
      expect(build_item.item.name).to eq('Test Item')
    end

    it 'is included in build items collection' do
      expect(build.build_items).to include(build_item)
    end

    it 'is included in item build_items collection' do
      expect(item.build_items).to include(build_item)
    end

    it 'enables build to access items through build_items' do
      expect(build.reload.items).to include(item)
    end

    it 'enables item to access builds through build_items' do
      expect(item.reload.builds).to include(build)
    end
  end
end
