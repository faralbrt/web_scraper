require 'mechanize'
require 'open-uri'
require 'openssl'
require 'nokogiri'
require_relative 'database'

cert_store = OpenSSL::X509::Store.new
cert_store.add_file 'cacert.pem'

$a = Mechanize.new { |agent|
  agent.cert_store = cert_store
  agent.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.87 Safari/537.36"
}



def scrape(asin_arr, agent)
  asin_arr.each do |asin|
    begin
      website = 'https://www.amazon.com/gp/offer-listing/' + asin + '/ref=olp_f_primeEligible?ie=UTF8&f_new=true&f_primeEligible=true'
      page = agent.get(website)
      title = page.at_xpath('//*[@id="olpProductDetails"]/div[1]/h1').text.strip
      price = grab_price(page)
      price_f = price.delete("$").to_f
      add_price(asin, title, price, price_f, current_date, current_date_i)
      sleep(rand(6.5))
    rescue Mechanize::ResponseCodeError
      add_price_empty(asin, "error", "error", current_date, current_date_i)
    end
  end
end

def grab_price(webpage)
  xpath_arr = ['//*[@id="olpOfferList"]/div/div/div[2]/div[1]/span[1]']
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
    return "can't grab price"
  end
end

def current_date
  Time.new.strftime("%m/%d/%y")
end

def current_hour
  Time.new.hour
end

def current_date_i
  Time.new.strftime("%y%m%d").to_i
end

# notes:
# A price can either be:
#  1. Sale 
#  2. Buybox if no sale
#  3. First Price if no buybox

# DRIVER CODE
# loop do
#   if last_date_i < current_date_i && (current_hour>= 0 && current_hour<= 5)
#     view_asins.each do |asin_arr|
#       scrape(asin_arr, a)
#     end
#   end
#   sleep(10,800)
# end

# begin
#   a.gto("Im not black")
# rescue Mechanize::ResponseCodeError
#   begin
#     a.get("https://amazon.com/dp/B12345")
#   rescue
#     puts "Could not find the page."
#   end
# rescue
#   puts "Some other error occurred."
# end

# page = $a.get("https://www.amazon.com/gp/offer-listing/B005JRGH0G/ref=olp_f_primeEligible?ie=UTF8&f_new=true&f_primeEligible=true")
# page = $a.get("https://www.amazon.com/gp/offer-listing/B002771T86/ref=dp_olp_new_mbc?ie=UTF8&condition=new")

# puts page.uri
# puts page.code
# puts page.response
# puts page.frames

# puts "_________________________________________________________________________________________________________________\n\n\n\n\n\n\n\n\n\n\n\n\n"

# puts page.at_xpath('//*[@id="olpOfferList"]/div/div/div[2]/div[1]/span[1]').text.strip
# puts page.at_xpath('//*[@id="olpOfferList"]/div/div/div[2]/div[1]/span[1]').text.strip

# puts "_________________________________________________________________________________________________________________\n\n\n\n\n\n\n\n\n\n\n\n\n"
# xpath_arr = ['//*[@id="priceblock_saleprice"]', '//*[@id="snsPrice"]/div/span[2]', '//*[@id="priceblock_ourprice"]', '//*[@id="mbc"]/div[2]/div/span[2]/div/div[1]/span']

# B01KJ76KEI,
# B01H5T7TH0,
# B003ZM91X2,
# B00O2TD2O6,
# B00NFZ3W6G,
# B01099LZC8,
# B000GFYWUS,
# B007TOJ4FC,
# B003WCR7O0,
# B002AOOCEO,
# B004QONP4O,
# B00C3YAEY8,
# B00ICT8NMI,
# B00XWQXSG2,
# B00L1I1VYY,
# B00HJCXX24,
# B003DCJEJK,
# B000HLEZVW,
# B00C84PTA2,
# B00863B5JI,
# B0077S7R8G,
# B002HQCYFE,
# B01DYPX52W,
# B004VU26F2,
# B000052YCX,
# B000KTB19K,
# B007N4D4ZO,
# B002771T86,
# B007E62538,
# B00P0C0PXA,
# B004D3485I,
# B0013QOIGC,
# B000UCW3EE,
# B00294Y65K,
# B000ZLQJHC,
# B000LNEB9W,
# B00I7V8WY0,
# B001E4GPVE,
# B00N54KWJ2,
# B00RU9IWRM,