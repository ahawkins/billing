module Billing
  module Helpers
    def debit_authorized?(object, *args)
      cost = current_tab.calculate object, *args
      current_tab.debit_authorized?(cost)
    end
    alias :charge_authorized :debit_authorized?

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
    alias :debit! :debit
    alias :charge :debit
    alias :charge! :debit

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
    alias :credit! :credit
    alias :refund :credit
    alias :refund! :credit

    def debit_for(multiple, object, *args, &block)
      cost = multiple * (current_tab.calculate object, *args)
      debit(cost, &block)
    end
    alias :debit_for! :debit_for
    alias :charge_for :debit_for
    alias :charge_for! :debit_for

    def credit_for(multiple, object, *args, &block)
      cost = multiple * (current_tab.calculate object, *args)
      credit(cost, &block)
    end
    alias :credit_for! :credit_for
    alias :refund_for :credit_for
    alias :refund_for! :credit_for
  end
end
