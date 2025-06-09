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
require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) { FactoryBot.build(:item) }
  subject { item }

  describe 'associations' do
    it { should have_many(:build_items).dependent(:restrict_with_exception) }

    it { should have_many(:builds).through(:build_items) }
  end

  describe 'constants' do
    it 'defines UNIQUE_COLUMNS' do
      expect(Item::UNIQUE_COLUMNS).to eq([:name])
    end

    it 'defines NO_SUBFORM_RELATIONS' do
      expect(Item::NO_SUBFORM_RELATIONS).to eq(['build_items'])
    end
  end

  describe 'enums' do
    let(:expected_types) { Item::ITEM_TYPE_VALUES.map(&:to_s) }
    let(:test_item_type) { Item::ITEM_TYPE_VALUES.sample.to_s }
    let(:invalid_item_type) { 'invalid_type' }

    it 'defines item_type enum with all expected values' do
      expect(Item.item_types.keys).to match_array(expected_types)
    end

    it 'can set and retrieve item_type' do
      item = FactoryBot.create(:item, item_type: test_item_type)
      expect(item.item_type).to eq(test_item_type)
      expect(item.public_send("#{test_item_type}?")).to be_truthy
    end

    it 'provides predicate methods for item types' do
      item = FactoryBot.create(:item, item_type: 'longswords')
      expect(item.longswords?).to be_truthy
      expect(item.boots?).to be_falsey
    end

    it 'does not allow invalid item_type values' do
      item = FactoryBot.build(:item, item_type: invalid_item_type)
      expect(item).not_to be_valid
    end
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:name) }

    it 'allows items with different names' do
      FactoryBot.create(:item, name: 'First Item')
      second_item = FactoryBot.build(:item, name: 'Second Item')

      expect(second_item).to be_valid
    end
  end

  describe 'Scrapeable concern' do
    it 'includes Scrapeable module' do
      expect(Item.ancestors).to include(Scrapeable)
    end

    it 'responds to new_from_scrape class method' do
      expect(Item).to respond_to(:new_from_scrape)
    end

    it 'responds to upsert_from_scrape class method' do
      expect(Item).to respond_to(:upsert_from_scrape)
    end
  end

  describe 'relationships with builds' do
    let(:item) { FactoryBot.create(:item) }
    let(:build1) { FactoryBot.create(:build) }
    let(:build2) { FactoryBot.create(:build) }

    it 'can be associated with multiple builds' do
      FactoryBot.create(:build_item, item: item, build: build1)
      FactoryBot.create(:build_item, item: item, build: build2)

      expect(item.builds).to include(build1)
      expect(item.builds).to include(build2)
      expect(item.builds.count).to eq(2)
    end

    it 'maintains associations when item attributes are updated' do
      FactoryBot.create(:build_item, item: item, build: build1)

      item.update!(description: 'Updated description')

      expect(item.builds).to include(build1)
    end
  end

  describe 'factory' do
    it 'creates a valid item with factory' do
      item = FactoryBot.build(:item)
      expect(item).to be_valid
    end

    it 'creates items with unique names using sequence' do
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)

      expect(item1.name).not_to eq(item2.name)
      expect(item1.name).to match(/Item \d+/)
      expect(item2.name).to match(/Item \d+/)
    end
  end

  describe 'attributes' do
    it 'has all expected attributes' do
      item = FactoryBot.create(:item,
        name: 'Test Item',
        description: 'Test Description',
        act: 'Act 1',
        effects: 'Magic effects',
        location: 'Test Location',
        rarity: 'Rare',
        uuid: 'test-uuid-123',
        weight: '2.5',
        price: '250'
      )

      expect(item.name).to eq('Test Item')
      expect(item.description).to eq('Test Description')
      expect(item.act).to eq('Act 1')
      expect(item.effects).to eq('Magic effects')
      expect(item.location).to eq('Test Location')
      expect(item.rarity).to eq('Rare')
      expect(item.uuid).to eq('test-uuid-123')
      expect(item.weight).to eq('2.5')
      expect(item.price).to eq('250')
    end
  end
end
