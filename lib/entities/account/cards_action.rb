module CardsAction
  TYPES = {
    usual: 'usual',
    capitalist: 'capitalist',
    virtual: 'virtual'
  }.freeze

  COMMANDS = {
    exit: 'exit',
    yes: 'y'
  }.freeze

  def create_card
    type = get_type
    return if type == COMMANDS[:exit]

    add_new_card type
    update_database
  end

  def show_cards
    cards.any? ? show(get_cards) : show(I18n.t('errors.cards'))
  end

  def destroy_card
    return show(I18n.t('errors.cards')) unless cards.any?

    index = get_index
    return if index == COMMANDS[:exit]

    delete_card index.to_i if accept? index.to_i
  end

  private

  def accept?(index)
    puts I18n.t 'output.cards.accept', number: cards[index - 1].number
    gets.chomp == COMMANDS[:yes]
  end

  def get_index
    loop do
      show I18n.t('output.cards.want_delete'), cards_with_index, I18n.t('output.exit')
      index = gets.chomp
      break index if index_valid? index

      show I18n.t('errors.wrong_number')
    end
  end

  def delete_card(index)
    cards.delete_at(index - 1)
    update_database
  end

  def type_valid?(type)
    TYPES.values.include? type
  end

  def get_type
    loop do
      type = from_input(I18n.t('account.create_card'))
      break type if type_valid? type

      show I18n.t('errors.card_type')
    end
  end

  def add_card(card)
    cards << card
  end

  def add_new_card(type)
    case type
    when TYPES[:usual] then add_card(UsualCard.new)
    when TYPES[:capitalist] then add_card(CapitalistCard.new)
    when TYPES[:virtual] then add_card(VirtualCard.new)
    end
  end
end
