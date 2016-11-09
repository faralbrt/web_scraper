require 'sinatra'
require 'sinatra/reloader'
require_relative 'webscraper'
require_relative 'database'

get '/' do
  erb :index
end

get '/:asin' do
  @asin = params[:asin]
  erb :asin
end


