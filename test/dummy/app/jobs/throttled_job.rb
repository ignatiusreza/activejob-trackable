# frozen_string_literal: true

class ThrottledJob < ApplicationJob
  include ActiveJob::Trackable::Throttled

  trackable throttled: 1.day

  def perform(*arguments); end
end
