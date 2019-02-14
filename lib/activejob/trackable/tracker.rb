# frozen_string_literal: true

module ActiveJob
  module Trackable
    class Tracker < ActiveRecord::Base # :nodoc:
      self.table_name = 'active_job_trackers'

      validates :provider_job_id, :key, presence: true
    end
  end
end
