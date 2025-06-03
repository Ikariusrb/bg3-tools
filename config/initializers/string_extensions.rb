# frozen_string_literal: true

class String
  def lstrip
    sub(/^[[:space:]]+/, '')
  end

  def rstrip
    sub(/[[:space:]]+$/, '')
  end

  # rubocop:disable Style/Strip
  def strip
    lstrip.rstrip
  end
  # rubocop:enable Style/Strip

  def plural?
    singularize != self && singularize.pluralize == self
  end
end
