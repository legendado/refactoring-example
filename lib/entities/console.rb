module Console
  private

  def run
    puts I18n.t :greeting
    gets.chomp
  end  

  def set_name
    puts I18n.t 'enter.name'
    gets.chomp      
  end

  def set_age
    puts I18n.t 'enter.age'
    gets.chomp
  end

  def set_login
    puts I18n.t 'enter.login'
    gets.chomp
  end

  def set_password
    puts I18n.t 'enter.password'
    gets.chomp
  end

  def create_new_account
    puts I18n.t 'enter.new_account'
    gets.chomp
  end
end
