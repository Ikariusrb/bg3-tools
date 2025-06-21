# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Companions, type: :model do
  # Reset class variable between tests to ensure clean state
  before do
    Companions.class_variable_set(:@@value, nil)
  end

  describe '#instance' do
    context 'when called for the first time' do
      it 'loads and parses the companions JSON file' do
        result = Companions.instance
        expect(result).to be_an(Array)
        expect(result).not_to be_empty
      end

      it 'caches the result in class variable' do
        expect(Companions.class_variable_get(:@@value)).to be_nil

        result = Companions.instance
        cached_value = Companions.class_variable_get(:@@value)

        expect(cached_value).to eq(result)
        expect(cached_value).not_to be_nil
      end
    end

    context 'when called multiple times' do
      it 'returns the same cached result' do
        first_call = Companions.instance
        second_call = Companions.instance

        expect(first_call).to eq(second_call)
        expect(first_call).to be(second_call) # Same object reference
      end

      it 'does not re-read the file on subsequent calls' do
        # First call loads the file
        Companions.instance

        # Mock File.read to ensure it's not called again
        expect(File).not_to receive(:read)

        # Second call should use cached value
        Companions.instance
      end
    end
  end
end
