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
    day DATE
    )
SQL

# METHODS FOR asins table
def add_asin(asin)
  $db.execute("INSERT INTO asins (asin) VALUES (?)", [asin])
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
def add_price(asin, title, price_s, price_i, day)
  $db.execute("INSERT INTO prices (asin, title, price_s, price_i, day) VALUES (?,?,?,?,?)", [asin, title, price_s, price_i, day])
end

def view_prices
  $db.execute("SELECT * FROM prices ORDER BY day DESC, asin ASC")
end

def last_date
  last_date = $db.execute("SELECT day FROM prices ORDER BY day DESC LIMIT 1")
  last_date = last_date[0][0].split('/')
  last_date = "#{last_date[2]}#{last_date[0]}#{last_date[1]}".to_i
  return last_date
end

def search_by_date(day)
  $db.execute("SELECT * FROM prices WHERE day=? ORDER BY asin ASC", [day])
end

def search_by_asin(asin)
  $db.execute("SELECT * FROM prices WHERE asin= ? ORDER BY day DESC", [asin])
end

def delete_day(day)
  $db.execute("DELETE FROM prices WHERE day = ?", [day])
end

def delete_asin_from_log(asin)
  $db.execute("DELETE FROM prices WHERE asin = ?", [asin])
end


# DRIVER CODE
$db.execute(create_asins_cmd)
$db.execute(create_prices_cmd)

# add_price("B0014DY7V0", "Dial 4 pack - roger's", "$15.49", 15.49, "11/09/16")
# puts view_prices
# puts "_________________________________________________"
# puts "Search by date"
# puts search_by_date("11/08/2016")
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