class VirtualCard < Card
  def initialize
    super
    @type = 'virtual'
    balance = 150.00
  end
end
