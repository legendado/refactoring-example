class Navigator
  include Validation
  include Database
  include Output
  include Money
  include Console

  START_COMMANDS = {
    create: 'create',
    load: 'load'
  }.freeze

  ACCOUNT_COMMANDS = {
    SC: 'SC'
    CC: 'CC',
    DC: 'load'
  }.freeze


  def initialize
    @errors = []
  end

  def console
    hello_phrases

    command = user_input
    case command
    when START_COMMANDS[:create] then create
    when START_COMMANDS[:load] then load
    else exit
    end
  end

  def main_menu
  end

  def create
  end

  def load
  end

  def destroy_account
  end

  def accounts
    load_account
  end
end
