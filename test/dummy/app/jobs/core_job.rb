# frozen_string_literal: true

class CoreJob < ApplicationJob
  include ActiveJob::Trackable

  def perform(*arguments); end
end
