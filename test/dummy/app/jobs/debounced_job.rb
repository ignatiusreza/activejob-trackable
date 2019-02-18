# frozen_string_literal: true

class DebouncedJob < ApplicationJob
  include ActiveJob::Trackable::Debounced

  def perform(*arguments); end

  private

    def key(foo, _extra)
      "foo-#{foo}"
    end
end
