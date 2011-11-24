require 'spec_helper'

class CallbackBank
  include Billing::Helpers
  include Billing::Extensions::Callbacks

  around_debit :around_debit_callback
  before_debit :before_debit_callback
  after_debit :after_debit_callback

  around_credit :around_credit_callback
  before_credit :before_credit_callback
  after_credit :after_credit_callback
end

describe CallbackBank do
  subject { CallbackBank.new }

  it "should be able to define itself" do
    # this tests that active model callbacks are included into
    # the class otherwise an error would be raised
    # when subject is evaluated
  end
end
