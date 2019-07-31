module UI
  def from_input(message)
    puts message
    gets.chomp
  end

  def show(*messages)
    puts(*messages)
  end

  def run
    puts I18n.t :HELLO
    gets.chomp
  end

  def set_name
    puts I18n.t 'ASK.name'
    gets.chomp
  end

  def set_age
    puts I18n.t 'ASK.age'
    gets.chomp
  end

  def set_login
    puts I18n.t 'ASK.login'
    gets.chomp
  end

  def set_password
    puts I18n.t 'ASK.password'
    gets.chomp
  end

  def create_new_account
    puts I18n.t 'COMMON.create_first_account'
    gets.chomp
  end

  def menu(name)
    puts I18n.t(:MAIN_MENU, name: name)
    gets.chomp
  end

  def wrong_command
    puts I18n.t 'ERROR.wrong_command'
  end

  def set_account_info
    {
      name: set_name,
      age: set_age,
      login: set_login,
      password: set_password
    }
  end

  def set_credentials
    {
      login: set_login,
      password: set_password
    }
  end

  def show_account_error
    puts I18n.t 'ERROR.user_not_exists'
  end

  def confirm?
    puts I18n.t('COMMON.destroy_account')
    gets.chomp == 'y'
  end

  # create card
  def take_type
    loop do
      type = from_input(I18n.t('CARDS.create_card'))
      break type if type_valid? type.downcase

      show I18n.t('ERROR.wrong_card_type')
    end
  end

  def type_valid?(type)
    %w[usual capitalist virtual].include? type
  end
  # =============================

  # destroy card
  def take_card_index
    loop do
      show(I18n.t('COMMON.if_you_want_to_delete'), cards_with_index, I18n.t(:EXIT))
      index = gets.chomp
      break index if index_valid? index

      show I18n.t('ERROR.wrong_number')
    end
  end

  def index_valid?(index)
    return true if index == 'exit'

    (index.to_i - 1).between? 0, @current_account.cards.size - 1
  end

  def cards_with_index
    @current_account.cards.map.with_index do |card, index|
      I18n.t('CARDS.card_with_index', number: card.number, type: card.type, index: index + 1)
    end
  end

  def accept?(index)
    puts I18n.t 'CARDS.confirm_deletion', number: @current_account.cards[index - 1].number
    gets.chomp == 'y'
  end
  # =============================
end
