require 'spec_helper'

class Biller
  include Billing::Helpers

  attr_accessor :tab

  def initialize(tab)
    @tab = tab
  end

  def current_tab
    tab
  end
end

describe Billing::Helpers do
  let(:tab) { double('tab') }
  subject { Biller.new(tab) }

  describe "#credit!" do
    it "should debit the cost when there is enough funds" do
      tab.stub(:balance).and_return(10)
      tab.stub(:calculate).with(:sms).and_return(2)

      tab.should_receive(:debit).with(2)

      subject.debit! :sms
    end

    it "should be able to authorize and commit when a block doesn't raise an error" do
      tab.stub(:balance).and_return(10)
      tab.stub(:calculate).with(:sms).and_return(2)

      tab.should_receive(:debit).with(2)

      subject.debit! :sms do 
        # nothin, just some code
      end
    end

    it "should not debit the account if the block raise an error" do
      tab.stub(:balance).and_return(10)
      tab.stub(:calculate).with(:sms).and_return(2)

      subject.should_not_receive(:debit)

      subject.debit! :sms do 
        raise "Blowing up your accounts!"
      end
    end

    it "should raise an error if there are not enough funds" do
      tab.stub(:balance).and_return(0)
      tab.stub(:calculate).with(:sms).and_return(2)

      lambda {
        subject.debit! :sms
      }.should raise_error(Billing::NotEnoughFunds)
    end
  end

  describe "#debit_for" do
    it "should charge for N for whatever it is" do
      tab.stub(:balance).and_return(20)
      tab.should_receive(:calculate).with(:sms).and_return(2)
      tab.should_receive(:calculate).with(10).and_return(10)

      tab.should_receive(:debit).with(10)

      subject.debit_for! 5, :sms
    end

    it "should be able to work with a block" do
      tab.stub(:balance).and_return(20)
      tab.should_receive(:calculate).with(:sms).and_return(2)
      tab.should_receive(:calculate).with(10).and_return(10)

      tab.should_not_receive(:debit).with(10)

      subject.debit_for! 5, :sms do
        raise RuntimeError
      end
    end
  end

  describe "#credit!" do
    it "should credit the cost if there is no block given" do
      tab.stub(:calculate).with(:sms).and_return(2)

      tab.should_receive(:credit).with(2)

      subject.credit! :sms
    end

    it "should credit when a block doesn't raise an error" do
      tab.stub(:calculate).with(:sms).and_return(2)

      tab.should_receive(:credit).with(2)

      subject.credit! :sms do 
        # nothin, just some code
      end
    end

    it "should not credit the account if the block raise an error" do
      tab.stub(:calculate).with(:sms).and_return(2)

      subject.should_not_receive(:credit)

      subject.credit! :sms do 
        raise "Blowing up your accounts!"
      end
    end
  end

  describe "#credit_for" do
    it "should credit for N for whatever it is" do
      tab.should_receive(:calculate).with(:sms).and_return(2)
      tab.should_receive(:calculate).with(10).and_return(10)

      tab.should_receive(:credit).with(10)

      subject.credit_for! 5, :sms
    end

    it "should be able to work with a block" do
      tab.should_receive(:calculate).with(:sms).and_return(2)
      tab.should_receive(:calculate).with(10).and_return(10)

      tab.should_not_receive(:credit).with(10)

      subject.credit_for! 5, :sms do
        raise RuntimeError
      end
    end
  end
end
