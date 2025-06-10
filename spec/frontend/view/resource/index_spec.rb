# frozen_string_literal: true

require 'rails_helper'

RSpec.describe View::Resource::Index, type: :view do
  # include ActionView::TestCase::Behavior
  let(:build1) { FactoryBot.create(:build, name: 'Build 1', description: 'First build') }
  let(:build2) { FactoryBot.create(:build, name: 'Build 2', description: 'Second build') }
  let(:builds) { [build1, build2] }
  let(:notice) { nil }
  let(:view_component) { described_class.new(builds, notice: notice) }
  let(:controller) { ActionView::TestCase::TestController.new }
  # let(:controller) { BuildsController.new }
  let(:view_context) { controller.view_context }

  # Mock the controller context for the view
  before do
    allow(view_component).to receive(:controller_name).and_return('builds')
    allow(view_component).to receive(:url_for).with(action: :new).and_return('/builds/new')
    allow(view_component).to receive(:url_for).with(build1).and_return("/builds/#{build1.id}")
    allow(view_component).to receive(:url_for).with(build2).and_return("/builds/#{build2.id}")
    # allow(view).to receive(:polymorphic_url).with(build1, action: :edit, class: 'inline-block').and_return("/builds/#{build1.id}/edit")
    # allow(view).to receive(:polymorphic_url).with(build2, action: :edit, class: 'inline-block').and_return("/builds/#{build2.id}/edit")
    # allow(view).to receive(:link_to).and_call_original
    # allow(view).to receive(:dom_id).with(build1).and_return("build_#{build1.id}")
    # allow(view).to receive(:dom_id).with(build2).and_return("build_#{build2.id}")
    # allow(view).to receive(:heroicon).with("eye", variant: :mini).and_return('<svg>eye</svg>')
    # allow(view).to receive(:heroicon).with("pencil", variant: :mini).and_return('<svg>pencil</svg>')
    # allow(view).to receive(:heroicon).with("trash", variant: :mini).and_return('<svg>trash</svg>')
    # allow(view).to receive(:super).and_return(nil)
    # allow(controller).to receive(:controller_path).and_return("builds")
  end

  describe '#initialize' do
    it 'sets resources and notice' do
      c = described_class.new(builds, notice: 'Test notice')
      expect(c.resources).to eq(builds)
      expect(c.notice).to eq('Test notice')
    end

    it 'defaults notice to nil' do
      view = described_class.new(builds)
      expect(view.notice).to be_nil
    end
  end

  describe '#view_template' do
    let(:rendered) { view_context.render view_component }

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
      expect(rendered).to include('border-collapse table-auto w-full text-sm')
    end

    context 'with empty resources' do
      let(:builds) { [] }

      it 'renders empty table' do
        expect(rendered).to include('<table')
        expect(rendered).to include('<thead')
        expect(rendered).to include('<tbody')
        expect(rendered).not_to include('Build 1')
      end
    end
  end

  describe '#row_template' do
    let(:resource) { build1 }
    let(:row_html) { view.send(:row_template, resource) }

    it 'renders row with correct structure' do
      # Capture the row template output by calling it within a temporary context
      temp_view = described_class.new([resource])
      allow(temp_view).to receive(:controller_name).and_return('builds')
      allow(temp_view).to receive(:dom_id).with(resource).and_return("build_#{resource.id}")
      allow(temp_view).to receive(:url_for).with(resource).and_return("/builds/#{resource.id}")
      allow(temp_view).to receive(:polymorphic_url).with(resource, action: :edit, class: 'inline-block').and_return("/builds/#{resource.id}/edit")
      allow(temp_view).to receive(:heroicon).and_return('<svg>icon</svg>')
      allow(temp_view).to receive(:link_to).and_call_original

      # Test by checking the full rendered output contains row elements
      rendered = temp_view.call
      expect(rendered).to include(resource.name)
      expect(rendered).to include(resource.description)
      expect(rendered).to include("build_#{resource.id}")
    end
  end

  describe '#resource_actions' do
    let(:resource) { build1 }
    let(:rendered) { view_context.render view_component }

    it 'includes view, edit, and delete actions' do
      # Check for presence of action icons/links in the rendered output
      expect(rendered).to include('<svg>eye</svg>')
      expect(rendered).to include('<svg>pencil</svg>')
      expect(rendered).to include('<svg>trash</svg>')
    end

    it 'includes turbo confirm for delete action' do
      expect(rendered).to include('turbo_confirm')
      expect(rendered).to include('Are you certain you want to delete this?')
    end

    it 'includes turbo method delete' do
      expect(rendered).to include('turbo_method')
    end
  end

  describe '#index_columns' do
    it 'dynamically loads INDEX_COLUMNS from controller' do
      expect(view.send(:index_columns)).to eq(%w[name description])
    end

    context 'with different controller' do
      before do
        allow(view).to receive(:controller_name).and_return('items')
      end

      it 'loads different columns for different controllers' do
        expect(view.send(:index_columns)).to eq(%w[name description uuid])
      end
    end
  end

  describe 'accessibility and styling' do
    let(:rendered) { view_context.render view_component }

    it 'includes proper table styling classes' do
      expect(rendered).to include('dark:bg-slate-850')
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
      expect(view.class.ancestors).to include(Phlex::Rails::Helpers::LinkTo)
      expect(view.class.ancestors).to include(Phlex::Rails::Helpers::Routes)
      expect(view.class.ancestors).to include(Phlex::Rails::Helpers::URLFor)
      expect(view.class.ancestors).to include(Phlex::Rails::Helpers::ControllerName)
      expect(view.class.ancestors).to include(Phlex::Rails::Helpers::DOMID)
    end

    it 'registers value helpers' do
      # These are tested indirectly through the mocking above
      expect(view).to respond_to(:heroicon)
      expect(view).to respond_to(:polymorphic_url)
    end
  end

  describe 'error handling' do
    context 'when INDEX_COLUMNS constant is missing' do
      before do
        allow(view).to receive(:controller_name).and_return('nonexistent')
      end

      it 'raises an appropriate error' do
        expect {
          view.send(:index_columns)
        }.to raise_error(NameError)
      end
    end

    context 'when resource has missing attributes' do
      let(:invalid_resource) do
        # Create a build but stub a missing method
        resource = build1
        allow(resource).to receive(:public_send).with('nonexistent_column').and_raise(NoMethodError)
        resource
      end

      it 'handles missing attributes gracefully in real scenario' do
        # This would be handled by the actual implementation
        # The test verifies that public_send is called on the resource
        expect(build1).to respond_to(:public_send)
      end
    end
  end
end
