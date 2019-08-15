class Database
  class << self
    def path(file_path = './db/accounts.yml')
      file_path
    end

    def load
      File.exist?(path) ? YAML.load_file(path) : []
    end

    def save(accounts)
      File.open(path, 'w') { |f| f.write accounts.to_yaml }
    end
  end
end
