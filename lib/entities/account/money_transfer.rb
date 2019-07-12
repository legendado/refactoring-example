module Money
  TYPES = {
    put: %w[choose_card input_amount],
    withdraw: %w[choose_card_withdrawing withdraw_amount]
  }.freeze

  def put_money
    card, amount = obtain_requisites(TYPES[:put])
    return if card.nil?

    return tax_error if less_than_tax? card.put_tax, amount

    put(card, amount)
  end

  def withdraw_money
    card, amount = obtain_requisites(TYPES[:withdraw])
    return if card.nil?

    withdraw(card, amount)
  end

  private

  def obtain_requisites(type)
    index = choose_card_index(type.first)
    return if index.nil? || index.zero?

    card = selected_card(index - 1)
    amount = enter_amount(type.last)

    return amount_error if amount <= 0

    [card, amount]
  end

  def put(card, amount)
    card.balance += amount * (1 - card.put_tax)
    puts I18n.t('MONEY.put', amount: amount, number: card.number,
                             balance: card.balance,
                             tax: amount * card.put_tax)
    update_database
  end

  def withdraw(card, amount)
    balance = amount * (1 - card.withdraw_tax)
    return money_error if balance.negative?

    card.balance = balance
    puts I18n.t('MONEY.withdraw', amount: amount, number: card.number,
                                  balance: card.balance,
                                  tax: amount * card.put_tax)
    update_database
  end

  def tax_error
    show I18n.t('ERROR.tax_higher')
  end

  def amount_error
    show I18n.t('ERROR.correct_amount')
  end

  def money_error
    show I18n.t('ERROR.not_enough')
  end

  def less_than_tax?(tax, amount)
    amount < tax
  end

  def enter_amount(type)
    amount = from_input(I18n.t("COMMON.#{type}"))
    amount.to_i
  end

  def choose_card_index(type)
    show I18n.t("COMMON.#{type}")
    return show(I18n.t('ERROR.no_active_cards')) unless cards.any?

    show cards_with_index, I18n.t(:EXIT)
    index = choose_index
    index.to_i
  end

  def choose_index
    index = gets.chomp
    index_valid?(index) ? index : show(I18n.t('ERROR.wrong_number'))
  end
end
