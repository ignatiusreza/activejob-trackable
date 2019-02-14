# frozen_string_literal: true

require 'test_helper'
require 'generators/active_job/trackable/trackable_generator'

module ActiveJob
  class TrackableGeneratorTest < Rails::Generators::TestCase
    tests ActiveJob::TrackableGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    test 'generating migration' do
      run_generator

      refute_empty Dir.glob destination_root.join('db/migrate/*_create_active_job_trackers.rb')
    end
  end
end
