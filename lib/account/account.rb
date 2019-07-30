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
    self.login != other.login
  end

  def create_card(card)
    @cards << card
  end

  def destroy_card(index)
    @cards.delete_at(index)
  end
end
