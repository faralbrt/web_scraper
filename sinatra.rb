require 'sinatra'
require 'sinatra/reloader'
require_relative 'webscraper'
require_relative 'database'

get '/' do
  erb :index
end

get '/history/:asin' do
  @asin = params[:asin]
  erb :asin
end

get '/addasin' do
  "Hello"
end

get '/deleteasin' do
  "Heyya!"
end