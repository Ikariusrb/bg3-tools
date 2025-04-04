class BuildItem < ApplicationRecord
  belongs_to :build
  belongs_to :item
end
