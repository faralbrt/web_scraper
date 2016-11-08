require 'mechanize'
require 'open-uri'
require 'openssl'
require 'nokogiri'

cert_store = OpenSSL::X509::Store.new
cert_store.add_file 'cacert.pem'

a = Mechanize.new { |agent|
  agent.cert_store = cert_store
  agent.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.87 Safari/537.36"
}

# asin = "B0014DY7V0"

# website = 'https://www.amazon.com/dp/' + asin + '/'

# page = a.get(website)

# title = page.at_xpath('//*[@id="productTitle"]').text.strip
# price = page.at_xpath('//*[@id="priceblock_saleprice"]').text
# rank = page.at_xpath('//*[@id="SalesRank"]/text()[1]')

# puts title + ":" + price

def scrape(asin_arr, a)
  asin_arr.each do |asin|
    website = 'https://www.amazon.com/dp/' + asin + '/'
    page = a.get(website)
    title = page.at_xpath('//*[@id="productTitle"]').text.strip
    price = page.at_xpath('//*[@id="priceblock_saleprice"]').text
    puts "#{title}: #{price}"
    sleep(3)
  end
end

# scrape(['B0014DY7V0', 'B005V04DG6'], a)

# def test(asin_arr, a)
#   asin_arr.each do |asin|
#     website = 'https://www.amazon.com/dp/' + asin + '/'
#     page = a.get(website)
#     title = page.at_xpath('//*[@id="productTitle"]').text.strip
#     price = page.at_xpath('//*[@id="mbc"]/div[2]/div/span[2]/div/div[1]/span').text.strip
#     puts "#{title}: #{price}"
#     sleep(3)
#   end
# end

# notes:
# A price can either be:
#  1. Sale 
#  2. Buybox if no sale
#  3. First Price if no buybox