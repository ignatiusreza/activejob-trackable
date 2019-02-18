# frozen_string_literal: true

module ActiveJob
  module Trackable
    class Tracker < ActiveRecord::Base # :nodoc:
      self.table_name = 'active_job_trackers'

      validates :provider_job_id, :key, presence: true

      def job
        @job ||= ActiveJob::Base.deserialize(job_data).tap do |job|
          job.provider_job_id = provider_job_id.to_i

          # this sux, but can't find other way around it
          job.send :deserialize_arguments_if_needed
          job.scheduled_at = provider_job.run_at.to_f
        end
      end

      protected

        def provider_job
          @provider_job ||= provider_job_id.presence && Delayed::Job.find(provider_job_id)
        end

      private

        def job_data
          provider_job.payload_object.job_data
        end
    end
  end
end
