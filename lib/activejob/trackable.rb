# frozen_string_literal: true

require 'activejob/trackable/railtie'
require_relative './trackable/tracker'
require_relative './trackable/core'
require_relative './trackable/debounced'
require_relative './trackable/throttled'

module ActiveJob
  # Extend `ActiveJob::Base` with the ability to track (cancel, reschedule, etc) jobs
  module Trackable
    extend ActiveSupport::Concern

    included do
      include Core
    end
  end
end
