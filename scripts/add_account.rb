require 'mysql2'
require './database_client'

DatabaseClient.add_account(ARGV[0], ARGV[1])
puts '********************************'
puts "Account is successfully created! Name:#{ARGV[0]}, Password:#{ARGV[1]}"
