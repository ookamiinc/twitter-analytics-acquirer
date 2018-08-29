require 'clockwork'
require 'active_support/all'
include Clockwork

every(1.days, 'script') do
  puts `ruby script.rb`
end
