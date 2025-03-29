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
end
