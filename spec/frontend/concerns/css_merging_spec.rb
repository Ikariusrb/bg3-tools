# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CSSMerging, type: :concern do
  # rubocop:disable Lint/ConstantDefinitionInBlock
  # Create a test class that includes the concern
  let(:test_class) do
    Class.new do
      include CSSMerging

      BUTTON_DEFAULT_CSS = "bg-blue-500 text-white px-4 py-2 rounded"
      CONTAINER_DEFAULT_CSS = "flex flex-col gap-4 p-6"
      INPUT_FIELD_DEFAULT_CSS = "border border-gray-300 px-3 py-2 rounded-md focus:outline-none"

      attr_reader :css

      def initialize(css: {})
        @css = css
      end
    end
  end
  # rubocop:enable Lint/ConstantDefinitionInBlock

  let(:test_instance) { test_class.new(css: css_hash) }
  let(:css_hash) { {} }

  describe '#merged_css' do
    context 'with no CSS overrides' do
      it 'returns only the default CSS classes' do
        expect(test_instance.merged_css(:button)).to eq("bg-blue-500 text-white px-4 py-2 rounded")
      end

      it 'works with different keys' do
        expect(test_instance.merged_css(:container)).to eq("flex flex-col gap-4 p-6")
        expect(test_instance.merged_css(:input_field)).to eq("border border-gray-300 px-3 py-2 rounded-md focus:outline-none")
      end

      it 'accepts string keys' do
        expect(test_instance.merged_css('button')).to eq("bg-blue-500 text-white px-4 py-2 rounded")
      end
    end

    context 'with CSS overrides' do
      let(:css_hash) do
        {
          button: "bg-red-500 px-6",
          container: "p-8 bg-gray-100",
          input_field: "border-2 border-blue-300"
        }
      end

      context 'with partial CSS overrides' do
        let(:css_hash) { { button: "hover:bg-blue-700" } }

        it 'adds new classes without removing defaults' do
          result = test_instance.merged_css(:button)
          expect(result).to include("bg-blue-500")
          expect(result).to include("text-white")
          expect(result).to include("px-4")
          expect(result).to include("py-2")
          expect(result).to include("rounded")
          expect(result).to include("hover:bg-blue-700")
        end
      end

      context 'with empty override strings' do
        let(:css_hash) { { button: "" } }

        it 'returns only default classes when override is empty' do
          expect(test_instance.merged_css(:button)).to eq("bg-blue-500 text-white px-4 py-2 rounded")
        end
      end

      context 'with nil values in css hash' do
        let(:css_hash) { { button: nil } }

        it 'treats nil as empty string' do
          expect(test_instance.merged_css(:button)).to eq("bg-blue-500 text-white px-4 py-2 rounded")
        end
      end

      context 'when constant is not defined' do
        it 'raises NameError for undefined constant' do
          expect {
            test_instance.merged_css(:nonexistent)
          }.to raise_error(NameError, /uninitialized constant.*NONEXISTENT_DEFAULT_CSS/)
        end
      end

      context 'when key is not in css hash' do
        let(:css_hash) { { other_key: "some-class" } }

        it 'uses empty string for missing keys' do
          expect(test_instance.merged_css(:button)).to eq("bg-blue-500 text-white px-4 py-2 rounded")
        end
      end
    end

    describe 'concern inclusion' do
      it 'includes the concern successfully' do
        expect(test_class.ancestors).to include(CSSMerging)
      end

      it 'provides merged_css method' do
        expect(test_instance).to respond_to(:merged_css)
      end

      it 'does not expose merger method publicly' do
        expect(test_instance).not_to respond_to(:merger)
      end
    end

    describe 'integration with TailwindMerge' do
      let(:css_hash) do
        {
          button: "bg-red-500 bg-green-500" # Conflicting background colors
        }
      end

      it 'uses TailwindMerge to resolve conflicts' do
        # TailwindMerge should keep the last conflicting class
        result = test_instance.merged_css(:button)
        expect(result).to include("bg-green-500")
        expect(result).not_to include("bg-red-500")
        expect(result).not_to include("bg-blue-500") # Original default
      end
    end
  end
end
