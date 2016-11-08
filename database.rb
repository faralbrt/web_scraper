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

def view_asins
  $db.execute("SELECT asin FROM asins ORDER BY asin ASC")
end

# METHODS FOR PRICES TABLE
def add_price(asin, title, price_s, price_i, day)
  $db.execute("INSERT INTO prices (asin, title, price_s, price_i, day) VALUES (?,?,?,?)", [asin, title, price_s, price_i, day])
end

def view_prices
  $db.execute("SELECT * FROM prices ORDER BY date DESC, asin ASC")
end

def search_by_date(day)
  $db.execute("SELECT * FROM prices WHERE day=? ORDER BY asin ASC", [day])
end

def search_by_asin(asin)
  $db.execute("SELECT * FROM prices WHERE asin= ? ORDER BY day DESC", [asin])
end


# DRIVER CODE
$db.execute(create_asins_cmd)
$db.execute(create_prices_cmd)
