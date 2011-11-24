module Billing
  module Tab
    def calculate(object, *args)
      if object.is_a? Symbol
        method_name = object.to_s
      elsif object.is_a?(Fixnum) || object.is_a?(Float) || object.is_a?(Bignum)
        return object
      elsif
        method_name = object.class.to_s.underscore
      end

      calculator = Billing.calculators.select do |c|
        c.new.respond_to? method_name
      end.first

      raise UnknownCost, object if calculator.nil?

      calculator_instance = calculator.new
      calculator_instance.tab = self

      if object.is_a? Symbol
        calculator_instance.send method_name, *args
      else 
        calculator_instance.send method_name, object
      end
    end
  end
end
