require 'sinatra/base'
require 'open-uri'

require ('./controllers/application')
require ('./controllers/source')
require ('./controllers/account')
require ('./models/account')
require ('./models/source')
require ('./models/account_source')


#Map resources to controllers
map('/account') { run AccountController}
map('/') { run SourceController}
