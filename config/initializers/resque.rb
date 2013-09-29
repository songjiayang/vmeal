require "redis"
require 'resque'

rails_root = Rails.root || File.dirname(__FILE__) + '/../..'
rails_env = Rails.env || 'development'
resque_config = YAML.load_file(rails_root.to_s + '/config/resque.yml')
Resque.redis = resque_config[rails_env]
Resque.redis.namespace = "newvmeal"
Dir["#{Rails.root}/lib/resque/*.rb"].each { |file| require file }
