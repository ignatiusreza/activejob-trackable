# frozen_string_literal: true

require 'test_helper'

module ActiveJob::Trackable
  class ThrottledTest < BaseTest
    attr_reader :now

    setup do
      Rails.cache.clear

      @now = Time.current
    end

    test 'throttling job to not run more than once within certain period' do
      travel_to now do
        tracker = assert_tracked { schedule_job.tracker }
        assert_equal 1.hour.from_now.to_f, tracker.job.scheduled_at

        job_was = tracker.job
        refute_job_enqueued do schedule_job end
        assert_equal job_was.job_id, tracker.reload.job.job_id
        assert_equal job_was.provider_job_id, tracker.reload.job.provider_job_id
      end
    end

    test 'throttling with a longer period than the job schedule' do
      tracker = travel_to(now) { assert_tracked { schedule_job.tracker } }

      travel_to 1.hour.since(now) - 1.second do
        refute_job_enqueued do schedule_job end
        assert_equal 1.second.from_now.to_f, tracker.reload.job.scheduled_at
      end

      travel_to 1.hour.since(now) do
        refute_job_enqueued do schedule_job end

        tracker.job.perform_now

        assert_raise ActiveRecord::RecordNotFound do
          tracker.reload
        end
      end

      travel_to 1.day.since(now) - 1.second do
        refute_job_enqueued do schedule_job end
      end

      travel_to 1.day.since(now) do
        assert_tracked do schedule_job end
      end
    end

    private

      def described_class
        ThrottledJob
      end

      def schedule_job
        described_class.set(wait: 1.hour).perform_later('foo')
      end
  end
end
