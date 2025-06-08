# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  NO_SUBFORM_RELATIONS = [].freeze

  primary_abstract_class
end
