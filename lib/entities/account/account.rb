class Account
  include Helper
  include CardsAction
  include Money

  attr_reader :name, :age, :login, :password
  attr_accessor :cards

  def initialize(args)
    @name = args[:name]
    @age = args[:age]
    @login = args[:login]
    @password = args[:password]
    @cards = []
  end
end
