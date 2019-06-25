module Validation
  def validate
    validate_name
    validate_age
    validate_login
    validate_password
  end

  def validate_name
    @errors << I18n.t :name_error if @name.empty? || !@name[0].match?(/[A-Z]/)
  end

  def validate_age
    @errors << I18n.t :age_error unless VALID[:age].include? @age.to_i
  end

  def validate_login
    @errors << I18n.t :login_error_empty if @login.empty?
    @errors << I18n.t :login_error_min if @login.size < VALID[:login].first
    @errors << I18n.t :login_error_max if @login.size > VALID[:login].last
    @errors << I18n.t :login_error_exists if account_exist?
  end

  def validate_password
    @errors << I18n.t :password_error_empty if @password.empty?
    @errors << I18n.t :password_error_min if @password.size < VALID[:password].first
    @errors << I18n.t :password_error_max if @password.size > VALID[:password].last
  end

  def account_exist?
  end
end
