ADMIN = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'admin_config.yml'))).result)
CONFIG = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'config.yml'))).result)
