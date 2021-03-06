source 'https://rubygems.org'

gemspec

eval_gemfile 'Gemfile.devtools'

unless defined?(COMPONENTS)
  COMPONENTS = %w(core repository changeset)
end

COMPONENTS.each do |component|
  gem "rom-#{component}", path: Pathname(__dir__).join(component).realpath
end

if ENV['USE_DRY_TRANSFORMER_MASTER'].eql?('true')
  gem 'dry-transformer', github: 'dry-rb/dry-transformer', branch: 'master'
end

group :sql do
  gem 'sequel', '~> 5.0'
  gem 'sqlite3', platforms: :ruby
  gem 'jdbc-sqlite3', platforms: :jruby
  gem 'jdbc-postgres', platforms: :jruby
  gem 'pg', platforms: :ruby
  gem 'dry-monitor'

  if ENV['USE_ROM_SQL_MASTER'].eql?('true')
    gem 'rom-sql', github: 'rom-rb/rom-sql', branch: 'master'
  else
    gem 'rom-sql', '~> 3.0'
  end
end

group :test do
  gem 'rspec', '~> 3.6'
end

group :docs do
  platform :ruby do
    gem 'redcarpet'
    gem 'yard'
    gem 'yard-junk'
  end
end

group :tools do
  gem 'pry'
  gem 'pry-byebug', platforms: :ruby
end

group :benchmarks do
  gem 'hotch', platforms: :ruby
  gem 'benchmark-ips'
  gem 'activerecord', '~> 5.0'
end
