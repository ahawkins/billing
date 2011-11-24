class BasicAccountCosts
  include Billing::Cost

  # bank.debit :somehting_cheap
  def something_cheap
    1
  end

  # bank.debit :something_more_complicated, :price => 5
  # bank.debit :something_more_complicated, :price => 10
  def something_more_complicate(options)
    options[:price] == 5 ? 5 : 10
  end

  # bank.credit a_record
  def something_with_an_instance(record)
    case record.plan
    when 'free' then
      0
    when 'cheap' then
      1
    when 'expensive' then
      1000
    end
  end
end
