module Money
  def put_money
    index = choose_card_index
    return if index.nil? || index.zero?

    card = selected_card(index - 1)
    amount = enter_amount

    return if invalid_amount? card.put_tax, amount

    put_on_card(card, amount)
  end

  def withdraw_money; end

  private

  def print_tax_error
    show I18n.t('ERROR.tax_higher')
  end

  def print_amount_error
    show I18n.t('ERROR.correct_amount')
  end

  def less_than_tax?(tax, amount)
    amount < tax
  end

  def enter_amount
    amount = from_input(I18n.t('COMMON.input_amount'))
    amount.to_i
  end

  def invalid_amount?(card, amount)
    return print_amount_error if amount <= 0
    return print_tax_error if less_than_tax? card, amount
    return false
  end

  def choose_card_index
    show I18n.t('COMMON.choose_card')
    return show(I18n.t('ERROR.no_active_cards')) unless cards.any?

    show cards_with_index, I18n.t(:EXIT)
    index = choose_index
    index.to_i
  end

  def choose_index
    index = gets.chomp
    index_valid?(index) ? index : show(I18n.t('ERROR.wrong_number'))
  end

  def put_on_card(card, amount)
    card.balance += amount * (1 - card.put_tax)
    puts I18n.t('MONEY.result_of_put', amount: amount, number: card.number,
                                      balance: card.balance,
                                      tax: card.put_tax)
    update_database
  end
end
