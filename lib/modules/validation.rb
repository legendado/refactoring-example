module Validation
  private

  VALID = {
    age: 23..90,
    login: 4..20,
    password: 6..30
  }.freeze

  def validate data
    validate_name data[:name]
    validate_age data[:age]
    validate_login data[:login]
    validate_password data[:password]
  end

  def validate_name name
    @errors << I18n.t('errors.name_error') if name.empty? || !name[0].match?(/[A-Z]/)
  end

  def validate_age age
    @errors << I18n.t('errors.age_error') unless VALID[:age].include? age.to_i
  end

  def validate_login login
    @errors << I18n.t('errors.login_error_empty') if login.empty?
    @errors << I18n.t('errors.login_error_min') if login.size < VALID[:login].first
    @errors << I18n.t('errors.login_error_max') if login.size > VALID[:login].last
    @errors << I18n.t('errors.login_error_exists') if account_exist? login
  end

  def validate_password password
    @errors << I18n.t('errors.password_error_empty') if password.empty?
    @errors << I18n.t('errors.password_error_min') if password.size < VALID[:password].first
    @errors << I18n.t('errors.password_error_max') if password.size > VALID[:password].last
  end

  def account_exist? login
    !accounts.detect { |account| account.login == login }.nil?
  end
end
