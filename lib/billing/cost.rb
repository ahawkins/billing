module Billing
  module Cost
    extend ActiveSupport::Concern

    included do
      Billing.calculators << self
    end

    attr_accessor :tab
  end
end
