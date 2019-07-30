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
      name:     set_name,
      age:      set_age,
      login:    set_login,
      password: set_password
    }
  end

  def set_credentials
    {
      login:    set_login,
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
end
