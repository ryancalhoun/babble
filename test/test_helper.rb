ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'database_cleaner'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  ActiveRecord::Migration.check_pending!
  DatabaseCleaner.strategy = :transaction
  DatabaseCleaner.clean_with :truncation
  setup { DatabaseCleaner.start }
  teardown { DatabaseCleaner.clean }

  # Add more helper methods to be used by all tests here...
end
