class Account
  attr_reader :name, :age, :login, :password, :cards

  def initialize(args)
    @name     = args[:name]
    @age      = args[:age]
    @login    = args[:login]
    @password = args[:password]
    @cards    = []
  end

  def access?(credentials)
    @login == credentials[:login] && @password == credentials[:password]
  end

  def equal?(other)
    @login == other.login
  end

  def add_card(card)
    @cards << card
  end

  def delete_card(index)
    @cards.delete_at(index)
  end
end
