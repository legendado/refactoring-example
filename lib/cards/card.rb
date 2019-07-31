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
    amount_with_tax = amount * (1 + withdraw_tax)

    @balance -= amount_with_tax if @balance > amount_with_tax
  end

  def put_tax; end

  def withdraw_tax; end

  private

  def generate_number
    16.times.map { rand(10) }.join
  end
end
