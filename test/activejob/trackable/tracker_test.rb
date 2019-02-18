# frozen_string_literal: true

require 'test_helper'

module ActiveJob::Trackable
  class TrackerTest < BaseTest
    test '#job reconstruct the original job ' do
      original_job = CoreJob.set(priority: 10, wait: 1.day).perform_later('foo', 'bar')
      reconstructed_job = original_job.tracker.job

      assert_equal original_job.arguments, reconstructed_job.arguments
      assert_equal original_job.job_id, reconstructed_job.job_id
      assert_equal original_job.priority, reconstructed_job.priority
      assert_equal original_job.provider_job_id, reconstructed_job.provider_job_id
      assert_equal original_job.queue_name, reconstructed_job.queue_name
      assert_equal original_job.tracker.key, reconstructed_job.tracker.key
      assert_in_delta original_job.scheduled_at, reconstructed_job.scheduled_at, 0.01
    end
  end
end
