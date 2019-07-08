class VirtualCard < Card
  def initialize
    super(balance: 150.00)
    @type = 'virtual'
  end

  def put_tax
    1
  end

  def withdraw_tax
    0.88
  end
end
