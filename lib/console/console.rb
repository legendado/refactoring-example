# rubocop:disable Metrics/ClassLength
class Console
  include Validation
  include UI

  COMMANDS = {
    create: 'create',
    load: 'load',
    show_cards: 'SC',
    create_card: 'CC',
    destroy_card: 'DC',
    put_money: 'PM',
    withdraw_money: 'WM',
    destroy_account: 'DA',
    exit: 'exit',
    yes: 'y'
  }.freeze

  def initialize
    @errors = []
  end

  def console
    case run
    when COMMANDS[:create]  then create
    when COMMANDS[:load]    then load
    else exit
    end
  end

  def create
    loop do
      data = set_account_info
      validate data
      break @current_account = Account.new(data) if @errors.empty?

      show_errors
    end

    Database.save accounts << @current_account
    main_menu
  end

  def load
    loop do
      return create_first_account if accounts.none?

      account = find_account(set_credentials)
      break @current_account = account unless account.nil?

      show_account_error
    end
    main_menu
  end

  def create_first_account
    return create if create_new_account == COMMANDS[:yes]

    console
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
  def main_menu
    loop do
      case menu(@current_account.name)
      when COMMANDS[:show_cards]      then show_cards
      when COMMANDS[:create_card]     then create_card
      when COMMANDS[:destroy_card]    then destroy_card
      when COMMANDS[:put_money]       then put_money
      when COMMANDS[:withdraw_money]  then withdraw_money
      when COMMANDS[:destroy_account] then destroy_account
      when COMMANDS[:exit]            then break exit
      else wrong_command
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity

  def show_cards
    @current_account.cards.any? ? show(take_cards) : show(I18n.t('ERROR.no_active_cards'))
  end

  def create_card
    type = take_type

    return if type == COMMANDS[:exit]

    @current_account.add_card(make_card(type))

    Database.save updated_accounts
  end

  def destroy_card
    return show(I18n.t('ERROR.no_active_cards')) if @current_account.cards.empty?

    index = take_card_index

    return if index == COMMANDS[:exit]

    if accept? index.to_i
      @current_account.delete_card(index.to_i - 1)
      Database.save updated_accounts
    end
  end

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

  def destroy_account
    Database.save without_self if confirm?
    exit
  end

  private

  # put and withdraw
  # helpers
  TYPES = {
    put: %w[choose_card input_amount],
    withdraw: %w[choose_card_withdrawing withdraw_amount]
  }.freeze

  def cards_with_index
    cards.map.with_index do |card, index|
      I18n.t('CARDS.card_with_index', number: card.number, type: card.type, index: index + 1)
    end
  end

  def selected_card(index)
    cards[index]
  end

  # methods

  def obtain_requisites(type)
    index = choose_card_index(type.first)
    return if index.nil? || index.zero?

    card = selected_card(index - 1)
    amount = enter_amount(type.last)

    return amount_error if amount <= 0

    [card, amount]
  end

  def put(card, amount)
    card.put(amount)
    puts I18n.t('MONEY.put', amount: amount, number: card.number,
                             balance: card.balance,
                             tax: card.put_tax)
    Database.save updated_accounts
  end

  def withdraw(card, amount)
    balance = card.balance - amount * (1 + card.withdraw_tax)
    return money_error if balance.negative?

    card.withdraw(amount)
    puts I18n.t('MONEY.withdraw', amount: amount, number: card.number,
                                  balance: card.balance,
                                  tax: amount * (1 + card.withdraw_tax))
    Database.save updated_accounts
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
  #================================

  def cards
    @current_account.cards
  end

  def make_card(type)
    eval("#{type.capitalize}Card.new")
  end

  def updated_accounts
    accounts.map do |account|
      account.not_equal?(@current_account) ? account : @current_account
    end
  end

  def without_self
    accounts.select { |account| account if account.not_equal?(@current_account) }
  end

  def find_account(data)
    accounts.detect { |account| account.equal?(data) }
  end

  def take_cards
    @current_account.cards.map { |card| I18n.t('CARDS.card', number: card.number, type: card.type) }
  end

  def show_errors
    @errors.each { |error| puts error }
    @errors = []
  end

  def accounts
    Database.load
  end
end
# rubocop:enable Metrics/ClassLength
