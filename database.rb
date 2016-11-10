require 'sqlite3'

# LOGIC
$db = SQLite3::Database.new("data.db")

# create table for asins
create_asins_cmd = <<-SQL
  CREATE TABLE IF NOT EXISTS asins (
    id INTEGER PRIMARY KEY,
    asin VARCHAR(255)
    )
SQL

# create table for prices
create_prices_cmd = <<-SQL
  CREATE TABLE IF NOT EXISTS prices (
    id INTEGER PRIMARY KEY,
    asin VARCHAR(255),
    title VARCHAR(255),
    price_s VARCHAR(255),
    price_i REAL,
    day DATE,
    day_i INT,
    cost INT
    )
SQL

# METHODS FOR asins table
def add_asin(asin)
  $db.execute("INSERT INTO asins (asin) VALUES (?)", [asin])
end

def add_multiple_asins(str)
  arr = str.split(',')
  arr.each do |asin|
    asin = asin.strip.upcase
    if asin.length == 10
      add_asin(asin.strip)
    end
  end
end

def delete_asin(asin)
  $db.execute("DELETE FROM asins WHERE asin = ?", [asin])
end

def delete_mult_asins(asin_arr)
  asin_arr.each do |asin|
    delete_asin(asin)
  end
end

def view_asins
  $db.execute("SELECT asin FROM asins ORDER BY asin ASC")
end

# METHODS FOR PRICES TABLE
def add_price(asin, title, price_s, price_i, day, day_i)
  $db.execute("INSERT INTO prices (asin, title, price_s, price_i, day, day_i) VALUES (?,?,?,?,?,?)", [asin, title, price_s, price_i, day, day_i])
end

def view_prices
  $db.execute("SELECT * FROM prices ORDER BY day_i DESC, title ASC")
end

# returns date as integer for sorting
def last_day_i
  last_date = $db.execute("SELECT day_i FROM prices ORDER BY day_i DESC LIMIT 1")
  last_date = last_date[0][0]
  return last_date
end

# returns date as a string
def last_date_s
  last_date = $db.execute("SELECT day FROM prices ORDER BY day_i DESC LIMIT 1")
  last_date = last_date[0][0]
  return last_date
end

def search_by_date(day)
  $db.execute("SELECT * FROM prices WHERE day=? ORDER BY title ASC", [day])
end

def search_by_asin(asin)
  $db.execute("SELECT * FROM prices WHERE asin= ? ORDER BY day_i DESC", [asin])
end

def search_by_asin_one(asin)
  $db.execute("SELECT * FROM prices WHERE asin= ? ORDER BY day_i DESC LIMIT 1", [asin])
end

def delete_day(day)
  $db.execute("DELETE FROM prices WHERE day = ?", [day])
end

def delete_asin_from_log(asin)
  $db.execute("DELETE FROM prices WHERE asin = ?", [asin])
end

# JOIN methods
def view_asins_titles
  $db.execute("SELECT asins.asin, prices.title FROM asins LEFT JOIN prices ON asins.asin = prices.asin GROUP BY prices.asin")
end

# DRIVER CODE
$db.execute(create_asins_cmd)
$db.execute(create_prices_cmd)

# add_asin("B0014DY7V0")
# add_price("B0014DY7V0", "eBags Slim Packing Cubes - 3pc Set", "$23.99", 23.99, "1/5/17", 170105)
# add_price("B0014DY750", "Dial 4 pack - green", "$15.49", 15.49, "1/5/17", 170105)
# puts view_prices
# puts "_________________________________________________"
# puts "Search by date"
# puts search_by_date(last_date_s)
# puts "__________________________________________________"
# puts "Search by asin"
# puts search_by_asin("B0014DY7V0")
# delete_asin_from_log("B0014DY7V0")
# p view_prices
# delete_asin("B0014DY7V0")
# p view_asins
# asin_arr = ["B0014DY7V0", "B005JRGH0G", "B01ABM71JY", "B00NFZ3W6G"]
# asin_arr.each do |asin|
#   add_asin(asin)
# end
