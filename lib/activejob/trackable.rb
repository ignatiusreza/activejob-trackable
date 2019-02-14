# frozen_string_literal: true

require 'activejob/trackable/railtie'
require_relative './trackable/tracker'

module ActiveJob
  # Extend ActiveJob with the ability to track (cancel, reschedule, etc) jobs
  module Trackable
    # Your code goes here...
  end
end
