if RUBY_VERSION == "1.9.2"
  require 'yaml'
  YAML::ENGINE.yamler= 'syck'
end

