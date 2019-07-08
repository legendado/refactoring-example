module Money
  def put_money
    show I18n.t('output.money.choose')
    return show(I18n.t('errors.cards')) unless cards.any?

    show cards_with_index, I18n.t('output.exit')
    index = get_index
    return if index == 'exit'

    put_on_card index.to_i - 1
  end

  def withdraw_money; end

  private

  def put_on_card(index)
    card = get_card(index)
    amount = from_input(I18n.t('output.money.amount'))
    return show(I18n.t('errors.tax')) if card.put_tax >= amount.to_i
    return show(I18n.t('errors.amount')) if amount.to_i.zero?

    card.balance += amount.to_i * (1 - card.put_tax)
    show I18n.t('output.money.put_result', amount: amount, number: card.number, balance: card.balance, tax: card.put_tax)
    update_database
  end

  def get_index
    index = gets.chomp
    if index_valid? index
      index
    else
      show I18n.t 'errors.wrong_number'
      'exit'
    end
  end
end
