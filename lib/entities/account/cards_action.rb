module CardsAction
  include Database

  TYPES = {
    usual: 'usual',
    capitalize: 'capitalize',
    virtual: 'virtual'
  }.freeze

  def create_card
    type = get_type
    return if type == 'exit'

    add_new_card type
    update_database
  end

  def show_cards
    cards.any? ? print_cards : show_error_cards
  end

  def destroy_card
    return show_error_cards unless cards.any?

    index = get_index
    return if index == 'exit'

    delete_card index.to_i if accept? index.to_i
  end

  private

  def accept? index
    puts I18n.t 'output.accept', number: self.cards[index - 1].number
    gets.chomp == 'y'
  end

  def get_index
    loop do
      index = set_index
      break index if index.to_i > 0 || index == 'exit'
      show_number_error
    end
  end

  def set_index
    puts I18n.t 'output.want_delete'
    self.cards.each_with_index do |card, index|
      puts I18n.t('output.deleting_card', number: card.number, type: card.type, index: index + 1)
    end
    puts I18n.t 'output.exit'
    gets.chomp
  end

  def show_number_error
    puts I18n.t 'errors.wrong_number'
  end

  def delete_card index
    self.cards.delete_at(index - 1)
    update_database
  end   
    
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
    cards.each { |card| puts(I18n.t('output.card', number: card.number, type: card.type)) }
  end

  def show_error_cards
    puts I18n.t 'errors.cards'
  end    
end
