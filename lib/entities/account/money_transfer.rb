module Money
  def put_money
    show I18n.t('COMMON.choose_card')
    return show(I18n.t('ERROR.no_active_cards')) unless cards.any?

    show cards_with_index, I18n.t(:EXIT)
    index = take_index
    return if index == 'exit'

    put_on_card index.to_i - 1
  end

  def withdraw_money; end

  private

  def put_on_card(index)
    card = take_card(index)
    amount = from_input(I18n.t('COMMON.input_amount'))
    return show(I18n.t('ERROR.correct_amount')) if amount.to_i <= 0
    return show(I18n.t('ERROR.tax_higher')) if card.put_tax >= amount.to_i

    card.balance += amount.to_i * (1 - card.put_tax)
    show(I18n.t('MONEY.result_of_put',
                amount: amount,
                number: card.number,
                balance: card.balance,
                tax: card.put_tax))
    update_database
  end

  def take_index
    index = gets.chomp
    if index_valid? index
      index
    else
      show I18n.t 'ERROR.wrong_number'
      'exit'
    end
  end
end
