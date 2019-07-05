module CardsAction
  include Database

  TYPES = {
    usual: 'usual',
    capitalize: 'capitalize',
    virtual: 'virtual'
  }.freeze

  def create_card
    add_new_card get_type
    update_database
  end

  def show_cards
    cards.any? ? print_cards : show_error_cards
  end

  def destroy_card
  end

  private

  def update_database
    save_accounts updated_accounts      
  end

  def updated_accounts
    accounts.map do |account|
      account.login == self.login ? self : account
    end
  end

  def type_valid? type
    TYPES.values.include? type
  end

  def set_type
    puts I18n.t 'account.create_card'
    gets.chomp
  end

  def show_type_error
    puts I18n.t 'errors.card_type'
  end

  def get_type
    loop do
      type = set_type
      break type if type_valid? type
      show_type_error
    end
  end

  def add_card card
    cards << card
  end

  def add_new_card type
    case type
    when TYPES[:usual] then add_card(UsualCard.new)
    when TYPES[:capitalize] then add_card(CapitalizeCard.new)
    when TYPES[:virtual] then add_card(VirtualCard.new)
    end
  end

  def print_cards
    cards.each { |card| puts("- #{card.number}, #{card.type}") }
  end

  def show_error_cards
    puts I18n.t 'errors.cards'
  end    
end
