# The most basic example possbile
class BasicAccount
  include Billing::Tab

  def initialize
    @balance = 0
  end

  def credit(amount)
    @balance = balance + amount
  end

  def debit(amount)
    @balance = balance - amount
  end

  def balance
    @balance
  end
end

# Store the current charges so they can possibly
# be flushed or readded later.

class AccountWithHolds
  def initalize(balance)
    @balance = 0
    @holds = 0
  end

  def balance
    @balance - @holds
  end

  def holds
    @holds
  end

  def debit(amount)
    if balance >= amount
      @balance = @balance - amount
      @holds = @holds + amount
    end
  end

  def credit(amount)
    if @holds > 0
      difference = @holds - amount
      @holds = @holds - amount
      @balance = @balance + difference
    else
      @balance = @balance + amount
    end
  end
end
