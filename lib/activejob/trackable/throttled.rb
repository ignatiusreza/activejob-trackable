# frozen_string_literal: true

module ActiveJob
  module Trackable
    ##
    # Include `ActiveJob::Trackable::Throttled` to throttle scheduling job when multiple jobs
    # with identical keys tried to be scheduled before it get performed
    #
    # Throtlling period are counted in relative to when the job is scheduled to run.
    # For example, is a job is configured to throttled every 1 day, and it is scheduled
    # to run in 5 hours; the throttling will be active for the full duration of 1 day and 5 hours
    #
    # Example:
    #
    #   ```
    #   class SampleJob < ActiveJob::Base
    #     include ActiveJob::Trackable::Throttled
    #
    #     trackable throttled: 1.day
    #
    #     def perform(one, two, three); end
    #   end
    #
    #   # schedule a job to run 1.hour.from_now
    #   SampleJob.set(wait: 1.hour).perform_later('foo', 'bar')
    #
    #   # less than 1 day later, trying to schedule the same job will silently fail
    #   SampleJob.set(wait: 2.hour).perform_later('foo', 'bar')
    #   ```
    #
    module Throttled
      extend ActiveSupport::Concern

      included do
        include Core
      end
    end
  end
end
