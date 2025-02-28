require 'sequel'

DB = Sequel.connect(adapter: 'sqlite', database: './test.db')
USER = DB[:users]
PRODUCT = DB[:products]
TEMPLATE = DB[:templates]
OPERATION = DB[:operations]