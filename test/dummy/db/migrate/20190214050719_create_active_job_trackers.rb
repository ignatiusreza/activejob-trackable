# frozen_string_literal: true

class CreateActiveJobTrackers < ActiveRecord::Migration[5.2]
  def change
    create_table :active_job_trackers, force: true do |t|
      t.string :provider_job_id, index: true
      t.string :key

      t.timestamps
    end
  end
end
