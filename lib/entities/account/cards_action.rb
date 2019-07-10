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
    type = take_type
    return if type == COMMANDS[:exit]

    add_new_card type
    update_database
  end

  def show_cards
    cards.any? ? show(take_cards) : show(I18n.t('ERROR.no_active_cards'))
  end

  def destroy_card
    return show(I18n.t('ERROR.no_active_cards')) unless cards.any?

    index = take_card_index
    return if index == COMMANDS[:exit]

    delete_card index.to_i if accept? index.to_i
  end

  private

  def accept?(index)
    puts I18n.t 'CARDS.confirm_deletion', number: cards[index - 1].number
    gets.chomp == COMMANDS[:yes]
  end

  def take_card_index
    loop do
      show(I18n.t('COMMON.if_you_want_to_delete'), cards_with_index, I18n.t(:EXIT))
      index = gets.chomp
      break index if index_valid? index

      show I18n.t('ERROR.wrong_number')
    end
  end

  def delete_card(index)
    cards.delete_at(index - 1)
    update_database
  end

  def type_valid?(type)
    TYPES.values.include? type
  end

  def take_type
    loop do
      type = from_input(I18n.t('CARDS.create_card'))
      break type if type_valid? type

      show I18n.t('ERROR.wrong_card_type')
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
