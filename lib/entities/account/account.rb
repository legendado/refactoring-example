class Account < Struct.new(:name, :age, :login, :password)
  include Helper
  include CardsAction
  include Money

  attr_accessor :cards

  def initialize(args)
    super(args[:name], args[:age], args[:login], args[:password])
    @cards = []
  end

  def equal?(data)
    login == data[:login] && password == data[:password]
  end
end
