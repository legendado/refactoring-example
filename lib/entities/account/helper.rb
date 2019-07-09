module Helper
  include Database

  private

  def from_input(message)
    puts message
    gets.chomp
  end

  def show(*messages)
    messages.each { |message| puts message }
  end

  def update_database
    save_accounts updated_accounts
  end

  def updated_accounts
    accounts.map do |account|
      account.login == login ? self : account
    end
  end

  def index_valid?(index)
    return true if index == 'exit'

    (index.to_i - 1).between? 0, cards.size - 1
  end

  def get_cards
    cards.map { |card| I18n.t('output.cards.card', number: card.number, type: card.type) }
  end

  def cards_with_index
    cards.map.with_index do |card, index|
      I18n.t('output.card_with_index', number: card.number, type: card.type, index: index + 1)
    end
  end

  def get_card(index)
    cards[index]
  end
end
