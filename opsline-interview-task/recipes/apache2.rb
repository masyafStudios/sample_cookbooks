execute 'update_apt-get' do
  command 'apt-get update'
  action :run
end

include_recipe 'apache2::default'
include_recipe 'apache2::mod_php5'
include_recipe 'apache2::mod_fastcgi'
