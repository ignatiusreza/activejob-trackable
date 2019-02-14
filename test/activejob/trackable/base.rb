# frozen_string_literal: true

class ActiveJob::Trackable::BaseTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    ActiveJob::Base.disable_test_adapter
    ActiveJob::Base.queue_adapter = :delayed_job
  end

  private

    def assert_change(counter)
      before = counter.call

      yield

      after = counter.call

      refute_equal before, after
    end

    def refute_change(counter)
      before = counter.call

      yield

      after = counter.call

      assert_equal before, after
    end
end
