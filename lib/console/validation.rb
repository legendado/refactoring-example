module Validation
  VALID_ACCOUNT_INFO = {
    age: 23..90,
    login: 4..20,
    password: 6..30
  }.freeze

  VALID_CARDS_TYPE = %w[usual capitalist virtual].freeze

  EXIT = 'exit'.freeze

  def type_valid?(type)
    VALID_CARDS_TYPE.include? type
  end

  def index_valid?(index)
    return true if index == EXIT

    (index.to_i - 1).between?(0, cards.size - 1)
  end

  def less_than_tax?(tax, amount)
    amount < tax
  end

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
    @errors << I18n.t('VALIDATION.age.length') unless VALID_ACCOUNT_INFO[:age].include? age.to_i
  end

  # rubocop:disable Metrics/AbcSize
  def validate_login(login)
    @errors << I18n.t('VALIDATION.login.present') if login.empty?
    @errors << I18n.t('VALIDATION.login.longer')  if login.size < VALID_ACCOUNT_INFO[:login].first
    @errors << I18n.t('VALIDATION.login.shorter') if login.size > VALID_ACCOUNT_INFO[:login].last
    @errors << I18n.t('VALIDATION.login.exists')  if account_exist? login
  end
  # rubocop:enable Metrics/AbcSize

  def validate_password(password)
    @errors << I18n.t('VALIDATION.password.present')  if password.empty?
    @errors << I18n.t('VALIDATION.password.longer')   if password.size < VALID_ACCOUNT_INFO[:password].first
    @errors << I18n.t('VALIDATION.password.shorter')  if password.size > VALID_ACCOUNT_INFO[:password].last
  end

  def account_exist?(login)
    accounts.any? { |account| account.login == login }
  end
end
