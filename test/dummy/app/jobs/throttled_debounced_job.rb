# frozen_string_literal: true

class ThrottledDebouncedJob < ApplicationJob
  include ActiveJob::Trackable::Debounced

  trackable throttled: 1.day

  def perform(*arguments); end

  private

    def key(foo, _extra)
      "foo-#{foo}"
    end
end
