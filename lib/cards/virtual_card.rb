class VirtualCard < Card
  def initialize
    super(type: 'virtual', balance: 150.00)
  end

  def put(amount)
    @balance += amount - put_tax if amount > put_tax
  end

  def put_tax
    1
  end

  def withdraw_tax
    0.12
  end
end
