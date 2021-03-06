require 'rubygems' #commented out ruby....maybe we should place this outside...lets see
require 'spork'
                   #uncomment the following line to use spork with the debugger
                   #require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  #require 'capybara/rspec'    # only required for capybara 2.0 and above....
  Capybara.javascript_driver = :webkit
  #:webkit for faster js tests  ,:selenium for full fledged browser



  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    config.include Rails.application.routes.url_helpers

    config.before(:suite) do
      DatabaseCleaner.clean_with :truncation
    end

    config.before(:each) do
      if example.metadata[:js]
        DatabaseCleaner.strategy = :truncation
      else
        DatabaseCleaner.strategy = :transaction
      end
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    # whenever we add a :focus tag to a given spec only that spec will be run instead of all of them...bcos of below 3 lines
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true

    #Adding Devise test helper methods sign_in and sign_out
    #config.include Devise::TestHelpers, :type => :controller


=begin   This is the original solution suggested....I modified it as below
    # Add global before/after blocks
    config.before :each do
      @old_stdout, @old_stderr = STDOUT, STDERR
    end

    config.after :each do
      STDOUT, STDERR = @old_stdout, @old_stderr
      # Some gems use $stdout and $stderr, instead of STDOUT and STDERR, replace those too
      $stdout, $stderr = @old_stdout, @old_stderr
    end
=end


  #And this is my own modified  solution
# Add global before/after blocks
    config.before :each do
      @old_stdout, @old_stderr = STDOUT, STDERR
    end

    config.after :each do
      STDOUT ||= @old_stdout
      STDERR ||= @old_stderr
      # Some gems use $stdout and $stderr, instead of STDOUT and STDERR, replace those too
      $stdout, $stderr = @old_stdout, @old_stderr
    end

  end
  ActiveSupport::Dependencies.clear # proposed here http://stackoverflow.com/questions/5913255/spork-and-cache-classes-problem-with-rspec-factory-girl-and-datamapper

end

Spork.each_run do
  # This code will be run each time you run your specs.
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.




