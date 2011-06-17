$LOAD_PATH.unshift(Dir.getwd)

require 'portfolio'

run Sinatra::Application
