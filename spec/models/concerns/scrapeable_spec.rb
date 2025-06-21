# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapeable, type: :concern do
  # Create test models and scrapers for testing
  let(:unique_columns_value) { %i[name] }
  let(:column_names) { %w[name description item_type rarity weight price] }

  let(:test_model_class) do
    klass = Class.new(ApplicationRecord) do
      self.table_name = 'items' # Use existing table for testing

      def self.name
        'TestModel'
      end
    end
    # Set constant outside the block to avoid RuboCop warning
    if not unique_columns_value.nil?
      klass.const_set(:UNIQUE_COLUMNS, unique_columns_value.freeze)
    end
    klass
  end

  before do
    allow(test_model_class).to receive(:column_names).and_return(column_names)
  end

  describe '#initialize' do
    context 'when model has UNIQUE_COLUMNS defined' do
      let(:column_names) { %w[description rarity weight] }
      let(:unique_columns_value) { %i[description] }
      it 'initializes without error' do
        expect {
          test_model_class.include(Scrapeable)
        }.not_to raise_error
      end
    end
    context 'when model has name column but no UNIQUE_COLUMNS' do
      let(:column_names) { %w[name description rarity weight] }
      let(:unique_columns_value) { nil }
      it 'initializes without error' do
        expect {
          test_model_class.include(Scrapeable)
        }.not_to raise_error
      end
    end
    context 'when model has neither UNIQUE_COLUMNS nor name column' do
      let(:column_names) { %w[description rarity weight] }
      let(:unique_columns_value) { nil }
      it 'raises NameError when including the concern' do
        expect {
          test_model_class.include(Scrapeable)
        }.to raise_error(NameError, /either UNIQUE_COLUMNS or a column named 'name' must be defined/)
      end
    end
  end
end
