# frozen_string_literal: true

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
