# -*- encoding : utf-8 -*-
require 'bundler/setup'
Bundler.require :default, :test

ENV['RACK_ENV'] ||= 'test'

spec_root = File.expand_path(File.dirname(__FILE__))
$: << spec_root
$: << File.expand_path(File.join(File.dirname(__FILE__), '..'))

Sinatra::Base.set :environment, :test

require File.join(File.dirname(__FILE__), '..', 'best_delivery')

Dir[File.join(spec_root, "support/**/*.rb")].each { |f| require f }

require 'factory_girl'
require File.expand_path(File.dirname(__FILE__) + '/factories.rb')

include Rack::Test::Methods

RSpec.configure do |config|
  config.color_enabled = true
  config.include Mongoid::Matchers

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
