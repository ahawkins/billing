require 'active_model/observing'

module Billing
  module Extensions
    module Observing
      extend ActiveSupport::Concern

      included do
        include ActiveModel::Observing
      end

      def debit(*args)
        self.class.notify_observers :before_debit, self, *args
        super
        self.class.notify_observers :after_debit, self, *args
      end
    end
  end
end
