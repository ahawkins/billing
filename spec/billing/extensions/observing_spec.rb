require 'spec_helper'

class ObservedBank
  include Billing::Helpers
  include Billing::Extensions::Observing
end

describe ObservedBank do
  subject { ObservedBank.new }
  let(:tab) { mock('tab').as_null_object }

  it "notify observers before a debit" do
    subject.stub(:current_tab).and_return(tab)

    #subject.class.should_receive(:notify_observers).with(:before_debit, subject, :these => :arguments)

    subject.debit :these => :arguments
  end
end
