# frozen_string_literal: true

require 'test_helper'

module ActiveJob::Trackable
  class DebouncedTest < BaseTest
    test 'rescheduling existing job if the same job gets enqueued multiple times' do
      travel_to Time.current.at_beginning_of_hour do
        tracker = assert_tracked {
          described_class.set(wait: 1.day).perform_later('bar', 'spicy').tracker
        }
        assert_equal 1.day.from_now.to_f, tracker.job.scheduled_at

        refute_change -> { ActiveJob::Trackable::Tracker.count } do
          described_class.set(wait: 10.minutes).perform_later('bar', 'spicy')
        end
        assert_equal 10.minutes.from_now.to_f, tracker.reload.job.scheduled_at

        refute_change -> { ActiveJob::Trackable::Tracker.count } do
          described_class.perform_later('bar', 'spicy')
        end
        assert_equal Time.current.to_f, tracker.reload.job.scheduled_at
      end
    end

    test 'arguments is updated when job gets rescheduled' do
      travel_to Time.current.at_beginning_of_hour do
        tracker = described_class.set(wait: 1.day).perform_later('bar', 'spicy').tracker
        assert_equal %w[bar spicy], tracker.job.arguments

        described_class.set(wait: 10.minutes).perform_later('bar', 'sour')
        assert_equal %w[bar sour], tracker.reload.job.arguments
      end
    end

    private

      def described_class
        DebouncedJob
      end
  end
end
