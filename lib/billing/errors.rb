module Billing
  class NotEnoughFunds < RuntimeError
    def initialize(cost, available_funds)
      @cost, @available_funds = cost, available_funds
    end

    def to_s
      %Q{Expected account to a mininum balance of "#{@cost}", but only had "#{@available_funds}"}
    end
  end

  class UnknownCost < RuntimeError
    def initialize(product)
      @product = product
    end

    def to_s
      %Q{Could not determine the cost of: "#{@product.inspect}"}
    end
  end
end
