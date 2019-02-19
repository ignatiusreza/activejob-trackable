# frozen_string_literal: true

require 'test_helper'

module ActiveJob::Trackable
  class CoreTest < BaseTest
    test 'enqueuing job creates new tracker' do
      job = assert_tracked { described_class.set(wait: 1.day).perform_later('foo', 'bar') }

      assert_equal 'core_job/foo/bar', job.tracker.key
    end

    test 'enqueuing immediately running job does not creates tracker' do
      refute_tracked do
        described_class.perform_later 'foo', 'bar'
      end
    end

    test 'enqueuing the same exact jobs multiple times should not be allowed' do
      described_class.set(wait: 1.day).perform_later('foo', 'bar')

      refute_tracked do
        assert_raise ActiveRecord::RecordNotUnique do
          described_class.set(wait: 1.day).perform_later('foo', 'bar')
        end
      end
    end

    test 'enqueuing the same jobs multiple times is allowed, as long as it generate different keys' do
      bar_job = described_class.set(wait: 1.day).perform_later('foo', 'bar')

      assert_nothing_raised do
        baz_job = described_class.set(wait: 1.day).perform_later('foo', 'baz')

        refute_equal bar_job.tracker.key, baz_job.tracker.key
      end
    end

    test 'tracker is removed once the respective job is performed' do
      job = described_class.set(wait: 1.day).perform_later('foo', 'bar')

      assert_predicate job.tracker, :present?

      job.perform_now

      assert_raise ActiveRecord::RecordNotFound do
        job.tracker.reload
      end
    end

    private

      def described_class
        CoreJob
      end
  end
end
