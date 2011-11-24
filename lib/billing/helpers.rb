module Billing
  module Helpers
    def debit_authorized?(object, *args)
      cost = current_tab.calculate object, *args
      current_tab.debit_authorized?(cost)
    end

    def debit(object, *args)
      cost = current_tab.calculate object, *args

      raise NotEnoughFunds unless debit_authorized?(cost)

      if block_given?
        begin
          yield
          current_tab.debit cost
          cost
        rescue ; end
      else
        current_tab.debit cost
        cost
      end
    end

    def credit(object, *args)
      cost = current_tab.calculate object, *args

      if block_given?
        begin
          yield
          current_tab.credit cost
          cost
        rescue ; end
      else
        current_tab.credit cost
        cost
      end
    end

    def debit_for(multiple, object, *args, &block)
      cost = multiple * (current_tab.calculate object, *args)
      debit(cost, &block)
    end

    def credit_for(multiple, object, *args, &block)
      cost = multiple * (current_tab.calculate object, *args)
      credit(cost, &block)
    end
  end
end
