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
    price_i REAL 
    )
SQL


# DRIVER CODE
$db.execute(create_asins_cmd)
$db.execute(create_prices_cmd)