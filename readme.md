# Billing

Billing is a simple library to credit and debit accounts. It provides a
simple interface to calculate costs for individual things inside an
application. It also provides a way to charge accounts with those costs.
It is a **very** lightweight library. 

Billing is designed as an abstract process where the implementation
details are left to the user. 

It **does not** do any of the following things:

1. Accept credit cards 
2. Talk to payment processors
3. Manage application subscriptions
4. Manage application service plans
5. Make any assumptions about the billing/finanical side of your
   application

It **does** do the following:

1. Allow you to debit accounts
2. Allow you to hold funds in accounts
3. Allow you to release funds in accounts
4. Define cost classes for calculating services fees for individual
   resources.
5. Allow you to implement any of the things it does not do in a standard
   fashion.
6. Give you a mixin to allow you to manage billing in any part of your
   application.
7. Allow you to implement guards based on an account's finanical
   standing.
8. Allow you to do the things it does not do by including extensions.

## General Use

Billing is generally insipired by CanCan. You include functionality into
what objects you want via modules. You define costs by creating one or
more classes and include a module. Billing only makes **3** fundamental
assumptions:

1. You will have a class that acts like `Billing::AccountExample`
2. You will have classes that include `Billing::Cost`
3. You will manage the accounts by including `Billing::Tab`

### Defining An Account

Here is an example account

```ruby
class Account
  # You do not have to check if there are enough
  # funds in the account. Billing does that sort
  # of stuff for you.
  #
  # The actions should be atomic!

  def debit_authorized?(amount)
  end

  def debit(amount)
  end

  def credit(amount)
  end
end
```

You could implement a stateless Account like this:

```ruby
class Account
  def initialize
    @balance = 0
  end

  def debit_authorized?(amount)
    @balance >= amount
  end

  def debit(amount)
    @balance = @balance - amount
  end

  def credit(amount)
    @balance = @balance + amount
  end
end
```

### Defining Costs

Now let's say your application deals with SMS. Sending a SMS costs a
fixed amount of money (for simplicity). Define a cost class to handle
that calcation. _You can do more complex calculations, but we'll go over
that later._

```ruby
class SmsCalculator
  include Billing::Cost

  def sms
    1
  end
end
```


### Creating an Account Manager

Now the final step is to create a handler. This class should do two
things:

1. `respond_to :current_tab => true`
2. `include Billing::Tab`

Here is an exampler

```ruby
class Biller
  include Billing::Tab

  def initialize(account)
    @account = account
  end

  def current_tab
    @account
  end
end
```

### Using the interface

At this point we are ready to start doing things on the account. Here is
an example:

```ruby
account = Account.new
bank = Biller.new account

# this ensures that the account has at least "1" in it. 
# It puts "1" into holds ensuring that it will be available
# when account is ready to take the debit
bank.charge_authorized? :sms 

# Charge something to their account
#
# This changes the account balance!
bank.debit! :sms

# Add something to their account
#
# This change the account balance!
bank.credit! :sms

# You can also use a Fixnum or Float
# if you want to credit or debit an arbitrary amount
bank.credit! 591
bank.debit! 382.75
```

### Calculating Costs

Cost class methods may be called in a variety of ways. Here are some
examples and the corresponding method call. Assume the `cost` refers to
an instance of a class with `Billing::Cost` included. Assume `bank` is
includes `Billing::Helpers`

Scenario: something always costs the same

```ruby
bank.debit :sms
# means
cost.sms()
```

Scenario: cost depends on an instance of the object

```ruby
sms = Sms.new
bank.debit sms
# means
cost.sms(sms)
```

Scenario: More information is needed to calculate a cost

```ruby
bank.debit :sms, :region => :north_america
# means
cost.sms(:region => :north_america)
```

```ruby
bank.debit Sms
# means
bank.debit :sms
```

### Handling Failure & Advanced Usage

Perhaps you want to hit the account only after you do some code. You can
pass the the `debit` and `credit` methods blocks. The debit or credit
will only hit the account if the block **does not raise an error.**

```ruby
bank.debit :sms, :region => :north_america do
  begin
    Gateway.deliver sms
  rescue GatewayError => ex
    # oh damn, the gateway may an error or something
    # even though the user's SMS is valid
    # they shouldn't be charged for this.
    log_exception ex
    raise RuntimeError
  end
end
```

You can credit/debit for multiple charges at once using `_for` methods.
They work the same way, except take an a numeric argument first to
multiply the charge by.

```ruby
bank.debit_for 5, :sms

bank.credit_for 13, :searches

bank.credit_for 5, :search, :engine => :hoovers do
  # whatever you need to do
end
```

## Extensions

Billings is designed to be extended via Modules. You can include more
modules into the managing class. Here is the current extension list:

1. Logging (can also be used for auditing)
2. Callbacks


### Logging

You can log (and audit) all transcations made through your managers by
including the `Billing::Extensions::Logging` into your class. The
default logger is `Logger.new($stdout).` Here is an example

```ruby
class Bank
  include Billings::Tab
  include Billings::Extensions::Logging

  # redefine the logger method if you want to use your own
  # custom logger.
  #
  # The class uses the "info" log level
  def logger
    Log4r.new $stdout
  end
end
```

### Callbacks

Enables `before_*`, `after_`, and `around_` callbacks on `debit` and
`credit`

```ruby
class Bank
  include Billings::Tab
  include Billings::Extensions::Callbacks

  after_debit :send_charge_notification

  after_credit :send_refund_notification

  def send_charge_notification
    # weeee
  end

  def send_refund_notification
    # weee
  end
end
```
