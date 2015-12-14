require 'sinatra/base'
require 'open-uri'

require ('./controllers/application')
require ('./controllers/source')
require ('./controllers/account')
require ('./controllers/category')
require ('./models/account')
require ('./models/source')
require ('./models/account_source')
require ('./models/category')
require ('./models/source_category')


#Map resources to controllers
map('/account') { run AccountController }
map('/category') { run CategoryController }
map('/') { run SourceController }
