# frozen_string_literal: true

module ActiveJob
  module Trackable
    ##
    # Extend `ActiveJob::Base` to automatically create a tracker for every enqueued jobs
    #
    # Tracker is only created if jobs is registered with a schedule (e.g by setting :wait options)
    #
    # Every Tracker will have their own `key`, which will be automatically generated from the
    # related job class name and the arguments passed in to #perform_later. Trackers are expected
    # to be unique by `key`.
    #
    # The default behaviour for generating key is quite minimalistic, so you might want to override
    # it if you're passing non-simple-value arguments
    #
    # Example:
    #
    #   ```
    #   class SampleJob < ActiveJob::Base
    #     include ActiveJob::Trackable
    #
    #     def perform(one, two, three); end
    #   end
    #
    #   # will generate tracker whose key = sample_job/foo/bar/1
    #   SampleJob.set(wait: 1.day).perform_later('foo', 'bar', 1)
    #   ```
    #
    module Core
      extend ActiveSupport::Concern

      included do
        before_enqueue do
          @tracker = nil
        end

        after_enqueue do |job|
          next unless job.scheduled_at && job.provider_job_id

          job.tracker.provider_job_id = job.provider_job_id
          job.tracker.save!
        end

        after_perform do |job|
          job.tracker&.destroy
        end
      end

      def tracker
        @tracker ||= Tracker.new key: key(*arguments)
      end

      private

        def key(*arguments)
          ([self.class.to_s.underscore] + arguments.map(&:to_s)).join('/')
        end
    end
  end
end
