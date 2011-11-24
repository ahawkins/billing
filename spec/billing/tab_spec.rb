require 'spec_helper'

class Cost
  include Billing::Cost

  def sms
    5
  end

  def push_notification
    3
  end
end

class Sms

end

class PushNotification

end

class TestTab
  include Billing::Tab
end

describe TestTab do
  let(:cost) { mock(Cost, :tab= => true) }

  before(:each) { Cost.stub(:new).and_return(cost) }

  describe "Calculating the cost of things" do
    describe "When there is no class to handle it" do
      it "should raise an error" do
        lambda { 
          subject.calculate :unknown_product
        }.should raise_error(Billing::UnknownCost)
      end
    end

    describe "When a symbol is passed" do
      it "should call the calculator with that method name" do
        cost.should_receive(:sms)

        subject.calculate :sms
      end

      it "should pass any extra arguments onto the calculator" do
        cost.should_receive(:sms).with(:region => :north_america)

        subject.calculate :sms, :region => :north_america
      end
    end

    describe "When an instance of something else is passed" do
      let(:sms) { Sms.new }
      let(:push_notification) { PushNotification.new }

      it "should call the calctor with the class name with itself" do
        cost.should_receive(:sms).with(sms)

        subject.calculate sms
      end

      it "should use the underscored version of the class name to find a method" do
        cost.should_receive(:push_notification).with(push_notification)

        subject.calculate push_notification
      end
    end
  end
end
