module UI
  COMMANDS = {
    create: 'create',
    load: 'load',
    show_cards: 'SC',
    create_card: 'CC',
    destroy_card: 'DC',
    put_money: 'PM',
    withdraw_money: 'WM',
    destroy_account: 'DA'
  }.freeze

  OPERATION_TYPES = {
    put: %w[choose_card input_amount],
    withdraw: %w[choose_card_withdrawing withdraw_amount]
  }.freeze

  YES = 'y'.freeze

  def enter(message)
    puts message
    gets.chomp
  end

  def show(*messages)
    puts(*messages)
  end

  def operation_result(card:, amount:, tax:, type:)
    puts I18n.t("MONEY.#{type}", amount: amount, number: card.number,
                                 balance: card.balance,
                                 tax: tax)
  end

  def tax_error
    puts I18n.t('ERROR.tax_higher')
  end

  def amount_error
    puts I18n.t('ERROR.correct_amount')
  end

  def money_error
    puts I18n.t('ERROR.not_enough')
  end

  def create_new_account
    puts I18n.t('COMMON.create_first_account')
    gets.chomp
  end

  def menu(name)
    puts I18n.t(:MAIN_MENU, name: name)
    gets.chomp
  end

  def wrong_command
    puts I18n.t('ERROR.wrong_command')
  end

  def set_account_info
    {
      name: enter(I18n.t('ASK.name')),
      age: enter(I18n.t('ASK.age')),
      login: enter(I18n.t('ASK.login')),
      password: enter(I18n.t('ASK.password'))
    }
  end

  def set_credentials
    {
      login: enter(I18n.t('ASK.login')),
      password: enter(I18n.t('ASK.password'))
    }
  end

  def show_account_error
    puts I18n.t('ERROR.user_not_exists')
  end

  def confirm?
    enter(I18n.t('COMMON.destroy_account')) == YES
  end

  def enter_amount(type)
    amount = enter(I18n.t("COMMON.#{type}"))
    amount.to_i
  end

  def choose_index
    index = gets.chomp
    index_valid?(index) ? index : show(I18n.t('ERROR.wrong_number'))
  end

  def take_type
    loop do
      type = enter(I18n.t('CARDS.create_card'))
      break type if type_valid?(type.downcase)

      show I18n.t('ERROR.wrong_card_type')
    end
  end

  def take_card_index
    loop do
      show(I18n.t('COMMON.if_you_want_to_delete'), cards_with_index, I18n.t(:EXIT))
      index = gets.chomp
      break index if index_valid?(index)

      show(I18n.t('ERROR.wrong_number'))
    end
  end

  def cards_with_index
    cards.map.with_index do |card, index|
      I18n.t('CARDS.card_with_index', number: card.number, type: card.type, index: index + 1)
    end
  end

  def accept?(index)
    puts I18n.t('CARDS.confirm_deletion', number: cards[index - 1].number)
    gets.chomp == YES
  end
end
