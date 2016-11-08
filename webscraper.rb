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



def scrape(asin_arr, agent)
  asin_arr.each do |asin|
    website = 'https://www.amazon.com/dp/' + asin + '/'
    page = agent.get(website)
    title = page.at_xpath('//*[@id="productTitle"]').text.strip
    price = grab_price(page)
    puts "#{title}: #{price}"
    sleep(3)
  end
end

def grab_price(webpage)
  xpath_arr = ['//*[@id="priceblock_saleprice"]', '//*[@id="snsPrice"]/div/span[2]', '//*[@id="priceblock_ourprice"]', '//*[@id="mbc"]/div[2]/div/span[2]/div/div[1]/span']
  price = nil;
  xpath_arr.each do |path|
    if price
      break
    else
      price = webpage.at_xpath(path)
    end
  end
  if price
    return price.text.strip
  else
    return "could not get price"
  end
end


# notes:
# A price can either be:
#  1. Sale 
#  2. Buybox if no sale
#  3. First Price if no buybox

# DRIVER CODE
# asin_arr = ["B0014DY7V0", "B005JRGH0G", "B01ABM71JY", "B00NFZ3W6G"]
# scrape(asin_arr, a)
