require 'logger'

module Billing
  module Extensions
    # This class logs all credit's and debit's to a logger method
    module Logging
      def credit!(*args)
        logger.info *args
        super
      end

      def debit!(*args)
        logger.info *args
        super
      end

      def logger
        @logger ||= Logger.new $stdout
      end
    end
  end
end
