# rubocop:disable Metrics/ClassLength
class Navigator
  include Validation
  include Database
  include Console

  START_COMMANDS = {
    create: 'create',
    load: 'load'
  }.freeze

  ACCOUNT_COMMANDS = {
    SC: 'SC',
    CC: 'CC',
    DC: 'DC',
    PM: 'PM',
    WM: 'WM',
    SM: 'SM',
    DA: 'DA',
    exit: 'exit'
  }.freeze

  YES = 'y'.freeze

  def initialize
    @errors = []
  end

  def console
    case run
    when START_COMMANDS[:create] then create
    when START_COMMANDS[:load] then load
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
    save
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
    case create_new_account
    when YES then create
    else console
    end
  end

  def main_menu
    loop do
      case menu(@current_account.name)
      when ACCOUNT_COMMANDS[:SC] then show_cards
      when ACCOUNT_COMMANDS[:CC] then create_card
      when ACCOUNT_COMMANDS[:DC] then destroy_card
      when ACCOUNT_COMMANDS[:PM] then put_money
      when ACCOUNT_COMMANDS[:WM] then withdraw_money
      when ACCOUNT_COMMANDS[:DA] then destroy_account
      when ACCOUNT_COMMANDS[:exit] then break exit
      else wrong_command
      end
    end
  end

  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity

  def destroy_account
    save_accounts without_self if confirm?
    exit
  end

  def withdraw_money
    @current_account.withdraw_money
  end

  def put_money
    @current_account.put_money
  end

  def show_cards
    @current_account.show_cards
  end

  def create_card
    @current_account.create_card
  end

  def destroy_card
    @current_account.destroy_card
  end

  private

  def confirm?
    puts I18n.t('COMMON.destroy_account')
    gets.chomp == YES
  end

  def without_self
    accounts.select { |account| account if account.login != @current_account.login }
  end

  def show_account_error
    puts I18n.t 'ERROR.user_not_exists'
  end

  def find_account(data)
    accounts.detect { |account| account.login == data[:login] && account.password == data[:password] }
  end

  def set_credentials
    {
      login: set_login,
      password: set_password
    }
  end

  def save
    save_accounts(accounts << @current_account)
  end

  def set_account_info
    {
      name: set_name,
      age: set_age,
      login: set_login,
      password: set_password
    }
  end

  def show_errors
    @errors.each { |error| puts error }
    @errors = []
  end
end
# rubocop:enable Metrics/ClassLength
