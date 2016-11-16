require 'sinatra'
require_relative 'webscraper'

set :public_folder, File.dirname(__FILE__) + '/static'
Thread.new do
  loop do
    if last_day_i < current_date_i && (current_hour>= 0 && current_hour<= 5)
      view_asins.each do |asin_arr|
        scrape(asin_arr, a)
      end
    end
    sleep(10,800)
  end

end

get '/' do
  begin
    if params['search_title'] && params['search_title'] != ""
      @search_title = params['search_title']
    else
      @search_title = nil
      @search_date = last_date_s
    end
    if params['search_date'] && params['search_date'] != ""
      @search_date = params['search_date'].chars
      @search_date.delete_at(6)
      @search_date.delete_at(6)
      @search_date = @search_date.join('')
    end
    erb :index
  rescue NoMethodError
    "This page is empty"
  end
end

get '/history/:asin' do
  @asin = params[:asin]
  if search_by_asin(@asin) != []
    erb :asin
  else
    "No History for this ASIN"
  end
end
get '/addasin' do
  erb :add_asin
end

get '/deleteasin' do
  erb :remove_asin
end

post '/addasin' do
  one_asin = params["one_asin"]
  @mult_asins = params["mult_asins"]
  if one_asin.nil? == false
    if one_asin.strip.length == 10
      add_asin(one_asin.strip.upcase)
      @success_asin = true
    end
  elsif @mult_asins.nil? == false
    if @mult_asins.empty? == false
      add_multiple_asins(@mult_asins)
      @success_mult_asins = true
    end
  end
  erb :add_asin
end

post '/deleteasin' do
  asin = params['asin_to_delete']
  delete_asin_from_log(asin)
  delete_asin(asin)
  erb :remove_asin
end
