class CapitalistCard < Card
  def initialize
    super(balance: 100.00)
    @type = 'capitalist'
  end

  def put_tax
    10
  end

  def withdraw_tax
    0.04
  end
end
