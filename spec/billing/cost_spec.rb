require 'spec_helper'

class TestCost 
  include Billing::Cost
end

describe TestCost do
  it "should register itself" do
    Billing.calculators.should include(TestCost)
  end
end
