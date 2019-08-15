class Card
  attr_reader :type, :number, :balance

  def initialize(type:, balance:)
    @number   = generate_number
    @type     = type
    @balance  = balance
  end

  def put(amount)
    @balance += amount * (1 - put_tax)
  end

  def withdraw(amount)
    @balance -= with_tax(amount) if @balance > with_tax(amount)
  end

  def put_tax; end

  def withdraw_tax; end

  private

  def generate_number
    16.times.map { rand(10) }.join
  end

  def with_tax(amount)
    amount * (1 + withdraw_tax)
  end
end
