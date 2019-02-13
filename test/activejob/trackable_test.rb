require 'test_helper'

class ActiveJob::Trackable::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, ActiveJob::Trackable
  end
end
