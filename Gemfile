source 'https://rubygems.org'

gem 'activesupport'
gem 'rake'

gem 'sinatra'
gem 'sinatra-activerecord'
gem 'sinatra-contrib'

gem 'puma'
gem 'tux'
gem 'redis', '~> 3.3'

# These gems are only installed when run as
# `bundle install --without production`
group :development, :test do
  gem 'pry'
  gem 'shotgun'
  gem 'sqlite3'
end

# bundle install --without test --without development
group :production do
  gem 'pg'
end
