# frozen_string_literal: true

class Companions
  @@value = nil

  def self.instance
    @@value = JSON.parse(File.read('data/companions.json')) if @@value.nil?
    @@value
  end
end
