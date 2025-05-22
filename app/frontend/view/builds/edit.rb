class View::Builds::Edit < Phlex::HTML
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::ControllerName
  include Phlex::Rails::Helpers::URLFor
  include Phlex::Rails::Helpers::FormTag
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::SelectTag
  include Phlex::Rails::Helpers::TurboFrameTag
  register_value_helper :heroicon


  attr_reader :resource, :action, :notice

  def initialize(resource, action:, notice: nil)
    @resource = resource
    @action = action
    @notice = notice
  end

  def view_template
    div(class: "mx-4 my-6 md:mx-6 lg:mx-8") do
      Components::Card(title: "Edit build") do
        turbo_frame_tag "build_form" do
          render View::Builds::EditForm.new(resource, action: action)
        end

        render View::BuildItems::SubForm.new(resource: resource, sub_resource: nil)
      end
    end
  end
end
