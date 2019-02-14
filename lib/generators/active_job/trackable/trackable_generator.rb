# frozen_string_literal: true

module ActiveJob
  ##
  #
  # Generator for generating activerecord migration for the table related to ActiveJob::Trackable::Tracker
  #
  # invoke with `rails generate active_job:trackable`
  #
  class TrackableGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('templates', __dir__)

    def self.next_migration_number(dirname)
      next_migration_number = current_migration_number(dirname) + 1

      if ActiveRecord::Base.timestamped_migrations
        [Time.now.utc.strftime('%Y%m%d%H%M%S'), format('%.14d', next_migration_number)].max
      else
        format('%.3d', next_migration_number)
      end
    end

    def create_migration_file
      migration_template 'migration.rb', migration_destination, migration_version: migration_version
    end

    private

      def migration_destination
        'db/migrate/create_active_job_trackers.rb'
      end

      def migration_version
        "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]" if ActiveRecord::VERSION::MAJOR >= 5
      end
  end
end
