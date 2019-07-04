class Account < Struct.new(:name, :age, :login, :password)
  def initialize(args)
    super(args[:name], args[:age], args[:login], args[:password])
    @cards = []
  end

  def equal? data
    login == data[:login] && password == data[:password]
  end

  def create_card
  end

  def show_cards
  end

  def destroy_card
  end
end
