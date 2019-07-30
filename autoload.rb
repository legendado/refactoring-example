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

# require_relative './lib/entities/database.rb'
# require_relative './lib/modules/validation.rb'
# require_relative './lib/entities/cards/card.rb'
# require_relative './lib/entities/cards/usual_card.rb'
# require_relative './lib/entities/cards/capitalist_card.rb'
# require_relative './lib/entities/cards/virtual_card.rb'
# require_relative './lib/entities/account/helper.rb'
# require_relative './lib/entities/account/money_transfer.rb'
# require_relative './lib/entities/account/cards_action.rb'
# require_relative './lib/entities/account/account.rb'
# require_relative './lib/entities/console.rb'
# require_relative './lib/entities/navigator.rb'
