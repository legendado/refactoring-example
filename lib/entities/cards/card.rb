class Card
  attr_reader :type, :number
  attr_accessor :balance

  def initialize
    @number = generate_number
  end 

  private

  def generate_number
    16.times.map { rand(10) }.join
  end 
end
