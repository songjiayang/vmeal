require 'yaml'

class HomeYaml

  def self.getYaml(filepath="config/home_page.yml")
    YAML.load_file(filepath)
  end
end