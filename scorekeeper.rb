require 'rubygems'
require 'active_record'

require File.dirname(__FILE__) + '/app/models.rb'
require File.dirname(__FILE__) + '/app/controllers.rb'
require File.dirname(__FILE__) + '/db/db_schema.rb'

path_to_sqlite_db = "db/scorekeeper.db"

#ActiveRecord::Base.logger = Logger.new(STDERR)
#ActiveRecord::Base.colorize_logging = true
if File.exists?('db/scorekeeper.db')
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3",:database  => path_to_sqlite_db )
  start
else
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3",:database  => path_to_sqlite_db )
  create_db_schema
  start
end
