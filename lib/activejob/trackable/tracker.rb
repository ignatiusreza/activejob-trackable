# frozen_string_literal: true

module ActiveJob
  module Trackable
    class Tracker < ActiveRecord::Base # :nodoc:
      self.table_name = 'active_job_trackers'

      validates :provider_job_id, :key, presence: true

      def track_job!(job)
        self.class.transaction do
          job.tracker.provider_job&.destroy!
          self.provider_job_id = job.provider_job_id
          save!
          dememoized!
        end
      end

      def job
        @job ||= ActiveJob::Base.deserialize(job_data).tap do |job|
          job.provider_job_id = provider_job_id.to_i

          # this sux, but can't find other way around it
          job.send :deserialize_arguments_if_needed
          job.scheduled_at = provider_job.run_at.to_f
        end
      end

      def reload
        dememoized!
        super
      end

      protected

        def provider_job
          @provider_job ||= provider_job_id.presence && Delayed::Job.find(provider_job_id)
        end

      private

        def dememoized!
          @job = nil
          @provider_job = nil
        end

        def job_data
          provider_job.payload_object.job_data
        end
    end
  end
end
