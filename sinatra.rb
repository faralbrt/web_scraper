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
  erb :add_asin
end

get '/deleteasin' do
  erb :remove_asin
end

post '/addasin' do
  @one_asin = params["one_asin"]
  @mult_asins = params["mult_asins"]
  if @one_asin.nil? == false
    if @one_asin.empty? == false
      
      @success_asin = true
    end
  elsif @mult_asins.nil? == false
    if @mult_asins.empty? == false
      @success_mult_asins = true
    end
  end
  erb :add_asin
end