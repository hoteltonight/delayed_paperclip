require 'resque'
require 'resque-retry'

module DelayedPaperclip
  module Jobs
    class Resque
      @queue = :paperclip

      def self.enqueue_delayed_paperclip(instance_klass, instance_id, attachment_name)
        queue = case instance_klass
                when "CustomerPhoto" then :customer_photo
                else
                  @queue
                end

        ::Resque.enqueue_to(queue, self, instance_klass, instance_id, attachment_name)
      end

      def self.perform(instance_klass, instance_id, attachment_name)
        DelayedPaperclip.process_job(instance_klass, instance_id, attachment_name)
      end
    end
  end
end