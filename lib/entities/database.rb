module Database
  def path(file_path = 'accounts.yml')
    file_path
  end

  def load_account
    File.exist?(path) ? YAML.load_file(path) : []
  end

  def save_accounts(accounts)
    File.open(path, 'w') { |f| f.write accounts.to_yaml }
  end

  alias accounts load_account
end
