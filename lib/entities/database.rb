module Database
  private

  PATH = 'accounts.yml'.freeze

  def load_account
    File.exist?(PATH) ? YAML.load_file(PATH) : []
  end

  def save_accounts accounts
    File.open(PATH, 'w') { |f| f.write accounts.to_yaml }
  end

  alias :accounts :load_account
end
