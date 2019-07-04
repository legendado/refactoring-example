class Navigator
  include Validation
  include Database
  # include Output
  # include Money
  include Console

  START_COMMANDS = {
    create: 'create',
    load: 'load'
  }.freeze

  ACCOUNT_COMMANDS = {
    SC: 'SC',
    CC: 'CC',
    DC: 'load'
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
    puts 'main menu'
  end

  def destroy_account
  end

  private

  def show_account_error
    puts I18n.t 'errors.account_finded'
  end

  def find_account data
    accounts.detect{ |account| account.equal? data }
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
