Rails.application.config.middleware.use OmniAuth::Builder do

  require 'openid/store/filesystem'

  # Facebook
  provider :facebook, '261239830568959', '96d840e8581cc3a37d879f36d7371b07', :client_options => {:ssl => {:ca_file => "/usr/lib/ssl/certs/ca-certificates.crt"}}

  # Vkontakte
  provider :vkontakte, '2021578', 'VMkRKx0KEpcgU2nyWVRN', :client_options => {:ssl => {:ca_file => "/usr/lib/ssl/certs/ca-certificates.crt"}}

  # Twitter
  provider :twitter, 'wqnfVR4yYPjnMDNn7tKfEA', '1MzyiRUQh0M4fBwZBfD5JkNs3GFLdDcgS1h6A7n4K8'

  # Google
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :client_options => {:ssl => {:ca_file => "/usr/lib/ssl/certs/ca-certificates.crt"}}, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'

end
