class UsualCard < Card
  def initialize
    super(type: 'usual', balance: 50.00)
  end

  def put_tax
    0.02
  end

  def withdraw_tax
    0.05
  end
end
