require 'rubygems'
require 'bundler/setup'

require 'active_support/all'
require 'json'

# Load Sinatra Framework (with AR)
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/contrib/all'
require 'redis'

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s

class Gallego < Sinatra::Application
  # Global Sinatra configuration
  configure do
    set :root, APP_ROOT.to_path
    set :server, :puma

    enable :sessions
    set :session_secret, ENV['SESSION_KEY'] || 'danielsecret'

    set :views, proc { File.join(root, 'app', 'views') }

    set :cache, Redis.new
  end

  # Development and Test Sinatra Configuration
  configure :development, :test do
    require 'pry'
  end

  # Production Sinatra Configuration
  configure :production do
    # NOOP
  end

  # Set up the database and models
  require APP_ROOT.join('config', 'database')

  # Load the routes / actions
  require APP_ROOT.join('app', 'actions')

  # Load helpers
  require_relative APP_ROOT.join('app', 'helpers', 'init')
end
