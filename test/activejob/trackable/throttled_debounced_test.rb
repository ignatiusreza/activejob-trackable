# frozen_string_literal: true

require 'test_helper'

module ActiveJob::Trackable
  class ThrottledDebouncedTest < BaseTest
    attr_reader :now

    setup do
      Rails.cache.clear

      @now = Time.current.at_beginning_of_hour
    end

    test 're-throttled when job are debounced' do
      tracker = travel_to(now) { assert_tracked { schedule_job.tracker } }

      travel_to 1.hour.since(now) do
        refute_job_enqueued do schedule_job end
      end
      assert_equal 3.hour.since(now).to_f, tracker.reload.job.scheduled_at

      travel_to 3.hour.since(now) do
        tracker.job.perform_now

        assert_raise ActiveRecord::RecordNotFound do
          tracker.reload
        end
      end

      travel_to 1.day.since(now) do
        refute_job_enqueued do
          schedule_job
        end
      end

      travel_to 1.day.since(3.hour.since(now)) - 1.second do
        refute_job_enqueued do schedule_job end
      end

      travel_to 1.day.since(3.hour.since(now)) do
        assert_tracked do schedule_job end
      end
    end

    test 'arguments is updated when job gets rescheduled' do
      now = Time.current

      tracker = travel_to(now) { schedule_job.tracker }
      assert_equal %w[bar spicy], tracker.job.arguments

      travel_to 1.hour.since(now) do
        schedule_job('bar', 'sour')
      end
      assert_equal %w[bar sour], tracker.reload.job.arguments
    end

    private

      def described_class
        ThrottledDebouncedJob
      end

      def schedule_job(foo = 'bar', extra = 'spicy')
        described_class.set(wait: 2.hour).perform_later(foo, extra)
      end
  end
end
