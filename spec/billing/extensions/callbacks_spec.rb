require 'spec_helper'

class CallbackBank
  include Billing::Helpers
  include Billing::Extensions::Callbacks

  before_debit :before_debit_callback
  after_debit :after_debit_callback

  before_credit :before_credit_callback
  after_credit :after_credit_callback

  def before_debit_callback ; end
  def after_debit_callback ; end

  def before_credit_callback ; end
  def after_credit_callback ; end
end

describe CallbackBank do
  subject { CallbackBank.new }
  before(:each) { subject.stub(:current_tab).and_return(double('tab').as_null_object) }

  it "should run callbacks on debit" do
    subject.should_receive(:before_debit_callback)
    subject.should_receive(:after_debit_callback)

    subject.debit :these => :args
  end

  it "should run callbacks on credit" do
    subject.should_receive(:before_credit_callback)
    subject.should_receive(:after_credit_callback)

    subject.credit :these => :args
  end
end
