# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResourceNaming, type: :concern do
  let(:resource_const) { nil }
  let(:resource_local) { nil }
  let(:resources_local) { nil }
  let(:controller_name_local) { nil }
  let(:parent_resource_const) { nil }
  let(:test_class) { Class.new }
  let(:test_instance) { test_class.new }

  before do
    test_class.const_set(:RESOURCE, resource_const) if not resource_const.nil?
    test_class.const_set(:PARENT_RESOURCE, resource_const) if not parent_resource_const.nil?

    if not resource_local.nil?
      test_class.define_method(:resource) { instance_variable_get(:@resource) }
      test_instance.instance_variable_set(:@resource, resource_local)
    end

    if not resources_local.nil?
      test_class.define_method(:resources) { instance_variable_get(:@resources) }
      test_instance.instance_variable_set(:@resources, resources_local)
    end

    if not controller_name_local.nil?
      test_class.define_method(:controller_name) { instance_variable_get(:@controller_name) }
      test_instance.instance_variable_set(:@controller_name, controller_name_local)
    end

    test_class.include(ResourceNaming)
  end

  describe '#resource_base' do
    context 'when RESOURCE constant is defined', focus: true do
      let(:resource_const) { "build" }

      it 'returns the value of the RESOURCE constant' do
        expect(test_instance.resource_base).to eq(resource_const)
      end
    end

    context 'when local variable resource is defined' do
      let(:resource_local) { Item.new }

      it 'returns the value of the resource variable' do
        expect(test_instance.resource_base).to eq(resource_local.class.name)
      end
    end

    context 'when resources local variable is defined' do
      let(:resources_local) { [Item.new, Build.new] }

      it 'returns the pluralized camelcased RESOURCE constant' do
        expect(test_instance.resource_base).to eq(resources_local.first.class.name)
      end
    end
  end

  describe '#parent_resource' do
    context 'when PARENT_RESOURCE constant is not defined' do
      it 'should not respond to parent_resource_plural' do
        expect(test_instance).not_to respond_to(:parent_resource_plural)
      end
    end
    context 'when PARENT_RESOURCE constant is defined' do
      let(:parent_resource_const) { "build" }

      it 'should respond to parent_resource_plural' do
        expect(test_instance).to respond_to(:parent_resource_plural)
      end
    end
  end
end
