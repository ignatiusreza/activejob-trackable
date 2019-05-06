# frozen_string_literal: true

require 'test_helper'

module ActiveJob::Trackable
  class DailyThrottledTest < BaseTest
    attr_reader :now

    setup do
      Rails.cache.clear

      @now = Time.current.at_beginning_of_day
    end

    test 'throttling recognize special period :daily' do
      tracker = travel_to(now) { assert_tracked { schedule_job.tracker } }

      travel_to 1.hour.since(now) do
        tracker.job.perform_now
      end

      travel_to now.at_end_of_day do
        refute_job_enqueued do schedule_job end
      end

      travel_to 1.day.since(now).at_beginning_of_day do
        assert_tracked do schedule_job end
      end
    end

    private

      def described_class
        DailyThrottledJob
      end

      def schedule_job
        described_class.set(wait: 1.hour).perform_later('foo')
      end
  end
end
