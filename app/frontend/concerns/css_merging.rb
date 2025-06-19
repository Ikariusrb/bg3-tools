# frozen_string_literal: true

# The CSSMerging concern provides utilities for merging default CSS classes with custom
# overrides using TailwindMerge to intelligently handle Tailwind CSS class conflicts.
#
# == Usage
#
# Include this concern in your Phlex components to enable CSS class merging:
#
#   class MyComponent < Phlex::HTML
#     include CSSMerging
#
#     BUTTON_DEFAULT_CSS = "bg-blue-500 text-white px-4 py-2 rounded"
#     CONTAINER_DEFAULT_CSS = "flex flex-col gap-4 p-6"
#     attr_reader :css
#
#     def initialize(css: {})
#       @css = css
#     end
#
#     def view_template
#       div(class: merged_css(:container)) do
#         button(class: merged_css(:button)) { "Click me" }
#       end
#     end
#   end
#
# == Required Constants
#
# For each CSS key you want to merge, define a corresponding constant with the pattern:
# `{KEY}_DEFAULT_CSS` where KEY is the uppercase version of your css key.
#
# Examples:
#   - For key `:button` → define `BUTTON_DEFAULT_CSS`
#   - For key `:container` → define `CONTAINER_DEFAULT_CSS`
#   - For key `:input_field` → define `INPUT_FIELD_DEFAULT_CSS`
#
# == CSS Hash Structure
#
# The css hash should be passed to your component's initializer and contain
# CSS class overrides for specific elements:
#
#   css = {
#     button: "bg-red-500 hover:bg-red-700",     # Override button styles
#     container: "p-8 bg-gray-100",             # Override container styles
#     input_field: "border-2 border-blue-300"  # Override input field styles
#   }
#
#
# == Error Handling
#
# If a required constant is not defined, a NameError will be raised.
# Ensure all constants are properly defined before calling merged_css.
#
module CSSMerging
  extend ActiveSupport::Concern

  def merged_css(key)
    defaults = self.class.const_get "#{key.upcase}_DEFAULT_CSS"
    overrides = css[key.to_sym] || ""
    merger.merge([defaults, overrides])
  end

  private

  def merger
    @merger ||= TailwindMerge::Merger.new
  end
end
