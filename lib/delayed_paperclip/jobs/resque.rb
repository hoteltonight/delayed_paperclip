require 'resque'

module DelayedPaperclip
  module Jobs
    class Resque
      extend ::Resque::Plugins::ExponentialBackoff
      @backoff_strategy = [0, 15, 30, 60]
      @queue = :paperclip

      def self.enqueue_delayed_paperclip(instance_klass, instance_id, attachment_name)
        ::Resque.enqueue(self, instance_klass, instance_id, attachment_name)
      end

      def self.perform(instance_klass, instance_id, attachment_name)
        if retry_attempt <= 1
          raise "Testing here"
        end
        DelayedPaperclip.process_job(instance_klass, instance_id, attachment_name)
      end
    end
  end
end