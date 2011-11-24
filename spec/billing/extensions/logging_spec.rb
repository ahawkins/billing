class LoggingBank
  include Billing::Helpers
  include Billing::Extensions::Logging
end

describe LoggingBank do
  let(:logger) { double('logger') }
  let(:bank) { LoggingBank.new }
  let(:tab) { mock('tab').as_null_object }

  before(:each) { Logger.stub(:new).and_return(logger) }

  it "should log calls to debit!" do
    subject.stub(:current_tab).and_return(tab)

    logger.should_receive(:info).with(:these => :arguments)

    subject.debit! :these => :arguments
  end

  it "should log calls to credit!" do
    subject.stub(:current_tab).and_return(tab)

    logger.should_receive(:info).with(:these => :arguments)

    subject.credit! :these => :arguments
  end
end
