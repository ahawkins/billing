require 'active_model/callbacks'

module Billing
  module Extensions
    module Callbacks
      extend ActiveSupport::Concern

      included do
        extend ActiveModel::Callbacks

        define_model_callbacks :credit, :debit
      end

      def debit!(*args)
        run_callbacks :debit do
          super
        end
      end

      def credit!(*args)
        run_callbacks :credit do
          super 
        end
      end
    end
  end
end
