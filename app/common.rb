require 'yaml'
module Common
		def self.config
			YAML.load_file('data.yml')
		end
end
