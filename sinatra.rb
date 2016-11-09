require 'sinatra'
require_relative 'webscraper'
require_relative 'database'

get '/' do
  erb :index
end



