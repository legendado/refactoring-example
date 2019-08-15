class CapitalistCard < Card
  def initialize
    super(type: 'capitalist', balance: 100.00)
  end

  def put(amount)
    @balance += amount - put_tax if amount > put_tax
  end

  def put_tax
    10
  end

  def withdraw_tax
    0.04
  end
end
