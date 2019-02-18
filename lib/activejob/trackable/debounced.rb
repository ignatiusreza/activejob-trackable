# frozen_string_literal: true

module ActiveJob
  module Trackable
    ##
    # Include `ActiveJob::Trackable::Debounced` to allow debouncing job when multiple jobs with identical keys
    # are scheduled before it get performed
    #
    # Example:
    #
    #   ```
    #   class SampleJob < ActiveJob::Base
    #     include ActiveJob::Trackable::Debounced
    #
    #     def perform(foo, bar)
    #       # do something
    #     end
    #
    #     private
    #
    #       def key(foo, bar)
    #         foo
    #       end
    #   end
    #
    #   # schedule a job to run 1.day.from_now
    #   SampleJob.set(wait: 1.day).perform_later('foo', 'bar')
    #
    #   # less than 1 day later, reschedule with updated options & arguments
    #   SampleJob.set(wait: 2.day).perform_later('foo', 'baz')
    #   ```
    #
    module Debounced
      extend ActiveSupport::Concern

      included do
        include Core

        trackable debounced: true
      end
    end
  end
end
