# frozen_string_literal: true

class DailyThrottledJob < ApplicationJob
  include ActiveJob::Trackable::Throttled

  trackable throttled: :daily

  def perform(*arguments); end
end
