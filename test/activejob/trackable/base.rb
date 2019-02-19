# frozen_string_literal: true

class ActiveJob::Trackable::BaseTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    ActiveJob::Base.disable_test_adapter
    ActiveJob::Base.queue_adapter = :delayed_job
  end

  private

    def assert_tracked
      assert_change -> { ActiveJob::Trackable::Tracker.count } do
        yield
      end
    end

    def refute_tracked
      refute_change -> { ActiveJob::Trackable::Tracker.count } do
        yield
      end
    end

    def refute_job_enqueued
      refute_tracked do
        refute_change -> { Delayed::Job.count } do
          yield
        end
      end
    end

    def assert_change(counter)
      before = counter.call

      yield.tap do
        after = counter.call

        refute_equal before, after
      end
    end

    def refute_change(counter)
      before = counter.call

      yield.tap do
        after = counter.call

        assert_equal before, after
      end
    end
end
