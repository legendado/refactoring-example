module Database
  PATH = 'accounts.yml'.freeze

  def load_accounts
    File.exist?(PATH) ? YAML.load_file('accounts.yml') : []
  end

  def save_accounts accounts
    File.open(PATH, 'w') { |f| f.write accounts.to_yaml }
  end
end
