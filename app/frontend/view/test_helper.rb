# frozen_string_literal: true

require "nokogiri"

module View::TestHelper
  def view_context
    controller.view_context
  end

  def controller
    @controller ||= ActionView::TestCase::TestController.new
  end

  def render(...)
    view_context.render(...)
  end

  def render_parsed(...)
    html = render(...)
    Nokogiri::HTML5(html)
  end
end
