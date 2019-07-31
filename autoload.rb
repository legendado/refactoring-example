require 'yaml'
require 'pry'
require 'i18n'

I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']
I18n.default_locale = :en

require_relative './db/database'

require_relative './lib/account/account'

require_relative './lib/cards/card.rb'
require_relative './lib/cards/usual_card.rb'
require_relative './lib/cards/capitalist_card.rb'
require_relative './lib/cards/virtual_card.rb'

require_relative './lib/console/ui'
require_relative './lib/console/validation'
require_relative './lib/console/console'
