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

  def destroy_account
    Database.save without_self if confirm?
    exit
  end

  def withdraw_money
  end

  def put_money
  end

  def show_cards
  end

  def create_card
  end

  def destroy_card
  end

  private

  def without_self
    accounts.select { |account| account if account.not_equal(@current_account) }
  end

  def find_account(data)
    accounts.detect { |account| account.equal?(data) }
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
