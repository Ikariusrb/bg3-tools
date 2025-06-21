# frozen_string_literal: true

class AllowNullBuildInPlaythroughBuilds < ActiveRecord::Migration[8.0]
  def change
    change_column_null :playthrough_builds, :build_id, true
  end
end
