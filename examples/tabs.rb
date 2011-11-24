class BasicAccountBank
  include Billing::Helpers

  def initialize(account)
    @account = account
  end

  def current_tab
    @account
  end

  def balance
    @account.balance
  end
end
