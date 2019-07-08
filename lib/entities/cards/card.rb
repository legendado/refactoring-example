class Card
  attr_reader :type, :number
  attr_accessor :balance

  def initialize(balance:)
    @number = generate_number
    @balance = balance
  end

  private

  def generate_number
    16.times.map { rand(10) }.join
  end
end
