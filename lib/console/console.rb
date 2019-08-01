# rubocop:disable Metrics/ClassLength
class Console
  include UI
  include Validation

  def initialize
    @errors = []
  end

  def console
    case enter(I18n.t(:HELLO))
    when COMMANDS[:create]  then create
    when COMMANDS[:load]    then load
    else exit
    end
  end

  def create
    loop do
      data = set_account_info

      validate(data)

      break @current_account = Account.new(data) if @errors.empty?

      show_errors
    end

    Database.save(accounts << @current_account)

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
    return create if create_new_account == YES

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
      when EXIT                       then break exit
      else wrong_command
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity

  def show_cards
    cards.any? ? show(take_cards) : show(I18n.t('ERROR.no_active_cards'))
  end

  def create_card
    type = take_type

    return if type == EXIT

    @current_account.add_card(make_card(type))

    Database.save(updated_accounts)
  end

  def destroy_card
    return show(I18n.t('ERROR.no_active_cards')) if cards.empty?

    index = take_card_index

    return if index == EXIT

    return unless accept?(index.to_i)

    @current_account.delete_card(index.to_i - 1)

    Database.save(updated_accounts)
  end

  def put_money
    card, amount = obtain_requisites(OPERATION_TYPES[:put])

    return if card.nil?

    return tax_error if less_than_tax?(card.put_tax, amount)

    put(card, amount)
  end

  def withdraw_money
    card, amount = obtain_requisites(OPERATION_TYPES[:withdraw])

    return if card.nil?

    return money_error if money_left(card, amount).negative?

    withdraw(card, amount)
  end

  def destroy_account
    Database.save(without_self) if confirm?

    exit
  end

  private

  def cards_with_index
    cards.map.with_index do |card, index|
      I18n.t('CARDS.card_with_index', number: card.number, type: card.type, index: index + 1)
    end
  end

  def money_left(card, amount)
    card.balance - amount * (1 + card.withdraw_tax)
  end

  def selected_card(index)
    cards[index]
  end

  def obtain_requisites(type)
    index = choose_card_index(type.first)

    return if index.nil? || index.zero?

    card    = selected_card(index - 1)
    amount  = enter_amount(type.last)

    return amount_error if amount <= 0

    [card, amount]
  end

  def put(card, amount)
    card.put(amount)

    operation_result(card: card, amount: amount, type: :put, tax: card.put_tax)

    Database.save(updated_accounts)
  end

  def withdraw(card, amount)
    balance = card.balance - amount * (1 + card.withdraw_tax)

    return money_error if balance.negative?

    card.withdraw(amount)

    operation_result(card: card, amount: amount, type: :withdraw, tax: calculate_withdraw_tax(card, amount))

    Database.save(updated_accounts)
  end

  def calculate_withdraw_tax(card, amount)
    amount * (1 + card.withdraw_tax)
  end

  def choose_card_index(type)
    show(I18n.t("COMMON.#{type}"))

    return show(I18n.t('ERROR.no_active_cards')) unless cards.any?

    show(cards_with_index, I18n.t(:EXIT))

    index = choose_index

    index.to_i
  end

  def make_card(type)
    Card.const_get("#{type.capitalize}Card").new
  end

  def updated_accounts
    accounts.map do |account|
      account.equal?(@current_account) ? @current_account : account
    end
  end

  def without_self
    accounts.select { |account| account unless account.equal?(@current_account) }
  end

  def find_account(data)
    accounts.detect { |account| account.access?(data) }
  end

  def take_cards
    cards.map { |card| I18n.t('CARDS.card', number: card.number, type: card.type) }
  end

  def show_errors
    @errors.each { |error| puts error }
    @errors = []
  end

  def accounts
    Database.load
  end

  def cards
    @current_account.cards
  end
end
# rubocop:enable Metrics/ClassLength
