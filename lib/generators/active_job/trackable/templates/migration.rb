# frozen_string_literal: true

class CreateActiveJobTrackers < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :active_job_trackers, force: true do |t|
      t.string :provider_job_id, index: true
      t.string :key, index: { unique: true }

      t.timestamps
    end
  end
end
