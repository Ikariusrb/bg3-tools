# frozen_string_literal: true

require 'rails_helper'

RSpec.describe View::Resource::Index, type: :view do
  include View::TestHelper
  let(:build1) { FactoryBot.create(:build, name: 'Build 1', description: 'First build') }
  let(:build2) { FactoryBot.create(:build, name: 'Build 2', description: 'Second build') }
  let(:resource) { [build1, build2] }
  let(:notice) { nil }
  let(:view_component) { described_class.new(resource, notice: notice) }
  let(:rendered) { render view_component }
  let(:parsed) { render_parsed view_component }

  # Mock the controller context for the view
  before do
    allow(view_component).to receive(:controller_name).and_return('builds')
  end

  describe '#initialize' do
    context 'with builds and notice' do
      let(:notice) { 'Test notice' }
      it 'sets resources and notice' do
        expect(view_component.resources).to eq(resource)
        expect(view_component.notice).to eq('Test notice')
      end
    end

    context 'with builds only' do
      let(:view_component) { described_class.new(resource) }
      it 'defaults notice to nil' do
        expect(view_component.notice).to be_nil
      end
    end
  end

  describe '#view_template' do
    context 'without notice' do
      it 'renders the view template' do
        expect(rendered).to be_a(String)
        expect(rendered).to include('Build 1')
        expect(rendered).to include('Build 2')
      end

      it 'does not display notice when nil' do
        expect(rendered).to include('<p style="color:#008000"></p>')
      end
    end

    context 'with notice' do
      let(:notice) { 'Operation successful!' }

      it 'displays the notice' do
        expect(rendered).to include('Operation successful!')
        expect(rendered).to include('<p style="color:#008000">Operation successful!</p>')
      end
    end

    it 'renders table structure' do
      expect(rendered).to include('<table')
      expect(rendered).to include('<thead')
      expect(rendered).to include('<tbody')
      expect(rendered).to include('</table>')
    end

    it 'renders table headers' do
      expect(rendered).to include('Name')
      expect(rendered).to include('Description')
      expect(rendered).to include('Actions')
    end

    it 'renders resource data' do
      expect(rendered).to include('Build 1')
      expect(rendered).to include('First build')
      expect(rendered).to include('Build 2')
      expect(rendered).to include('Second build')
    end

    it 'includes New button' do
      expect(rendered).to include('New')
      expect(rendered).to include('bg-blue-500')
    end

    it 'applies correct CSS classes' do
      expect(rendered).to include('flex flex-row place-content-center')
      expect(rendered).to include('relative overflow-auto basis-11/12')
      expect(rendered).to include('border rounded-lg overflow-hidden my-8')
    end

    context 'with empty resources' do
      let(:resource) { [] }

      it 'renders empty table' do
        expect(rendered).to include('<table')
        expect(rendered).to include('<thead')
        expect(rendered).to include('<tbody')
        expect(rendered).not_to include('Build 1')
      end
    end

    context 'with two builds' do
      let(:resource) { [build1, build2] }

      it 'renders both builds in the table' do
        expect(rendered).to include(build1.name)
        expect(rendered).to include(build2.name)
        expect(rendered).to include(build1.description)
        expect(rendered).to include("build_#{build1.id}")
      end
    end
  end

  describe '#resource_actions' do
    # let(:rendered) { view_context.render view_component }

    xit 'includes view, edit, and delete actions', focus: true do
      # Check for presence of action icons/links in the rendered output
      expect(rendered).to include('<svg>eye</svg>')
      expect(rendered).to include('<svg>pencil</svg>')
      expect(rendered).to include('<svg>trash</svg>')
    end

    it 'includes turbo confirm for delete action' do
      expect(rendered).to include('data-turbo-confirm')
      expect(rendered).to include('Are you certain you want to delete this?')
    end

    it 'includes turbo method delete' do
      expect(rendered).to include('data-turbo-method="delete"')
    end
  end

  describe '#index_columns' do
    let(:index_columns_result) { view_component.__send__(:index_columns) }
    it 'dynamically loads INDEX_COLUMNS from controller' do
      expect(index_columns_result).to eq(%w[name description])
    end

    context 'with different controller' do
      before do
        allow(view_component).to receive(:controller_name).and_return('items')
      end

      it 'loads different columns for different controllers' do
        expect(index_columns_result).to eq(%w[name description uuid])
      end
    end
  end

  describe 'accessibility and styling' do
    it 'includes proper table styling classes' do
      expect(rendered).to include('bg-white dark:bg-slate-800')
      expect(rendered).to include('even:bg-slate-800 odd:bg-slate-600')
    end

    it 'includes responsive design classes' do
      expect(rendered).to include('flex')
      expect(rendered).to include('basis-11/12')
      expect(rendered).to include('overflow-auto')
    end

    it 'includes proper button styling' do
      expect(rendered).to include('bg-blue-500')
      expect(rendered).to include('hover:bg-blue-700')
      expect(rendered).to include('text-white')
      expect(rendered).to include('font-bold')
      expect(rendered).to include('rounded')
    end

    it 'includes proper spacing and layout' do
      expect(rendered).to include('gap-4')
      expect(rendered).to include('p-2')
      expect(rendered).to include('p-4')
      expect(rendered).to include('my-8')
    end
  end

  describe 'helper method integration' do
    it 'uses Phlex::Rails helpers' do
      expect(view_component.class.ancestors).to include(Phlex::Rails::Helpers::LinkTo)
      expect(view_component.class.ancestors).to include(Phlex::Rails::Helpers::ControllerName)
    end

    it 'registers value helpers' do
      # These are tested indirectly through the mocking above
      expect(view).to respond_to(:heroicon)
      expect(view).to respond_to(:polymorphic_url)
    end
  end
end
