module Validation
  VALID = {
    age: 23..90,
    login: 4..20,
    password: 6..30
  }.freeze

  def validate(data)
    validate_name data[:name]
    validate_age data[:age]
    validate_login data[:login]
    validate_password data[:password]
  end

  def validate_name(name)
    @errors << I18n.t('VALIDATION.name.first_letter') if name.empty? || !name[0].match?(/[A-Z]/)
  end

  def validate_age(age)
    @errors << I18n.t('VALIDATION.age.length') unless VALID[:age].include? age.to_i
  end

  # rubocop:disable Metrics/AbcSize
  def validate_login(login)
    @errors << I18n.t('VALIDATION.login.present') if login.empty?
    @errors << I18n.t('VALIDATION.login.longer') if login.size < VALID[:login].first
    @errors << I18n.t('VALIDATION.login.shorter') if login.size > VALID[:login].last
    @errors << I18n.t('VALIDATION.login.exists') if account_exist? login
  end
  # rubocop:enable Metrics/AbcSize

  def validate_password(password)
    @errors << I18n.t('VALIDATION.password.present') if password.empty?
    @errors << I18n.t('VALIDATION.password.longer') if password.size < VALID[:password].first
    @errors << I18n.t('VALIDATION.password.shorter') if password.size > VALID[:password].last
  end

  def account_exist?(login)
    !accounts.detect { |account| account.login == login }.nil?
  end
end
