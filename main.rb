if ENV['RACK_ENV'] != 'production'
  require 'dotenv/load'
end

require 'sinatra'
require 'json'

get '/' do
  "#{request.ip}".to_json
end