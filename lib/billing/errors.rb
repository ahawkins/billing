module Billing
  class NotEnoughFunds < RuntimeError ; end

  class UnknownCost < RuntimeError
    def initialize(product)
      @product = product
    end

    def to_s
      %Q{Could not determine the cost of: "#{@product.inspect}"}
    end
  end
end
