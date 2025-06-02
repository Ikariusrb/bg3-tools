# frozen_string_literal: true

class String
  def lstrip
    sub(/^[[:space:]]+/, '')
  end

  def rstrip
    sub(/[[:space:]]+$/, '')
  end

  def strip
    lstrip.rstrip
  end

  def plural?
    self.singularize != self && self.singularize.pluralize == self
  end
end
