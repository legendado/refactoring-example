class Account
  attr_reader :name, :age, :login, :password, :cards

  def initialize(args)
    @name     = args[:name]
    @age      = args[:age]
    @login    = args[:login]
    @password = args[:password]
    @cards    = []
  end

  def equal?(data)
    @login == data[:login] && @password == data[:password]
  end

  def not_equal?(other)
    login != other.login
  end

  def add_card(card)
    @cards << card
  end

  def delete_card(index)
    @cards.delete_at(index)
  end
end
