chef_gem "chef-vault" do
  compile_time false if respond_to?(:compile_time)
end

include_recipe 'chef-vault'

db_user = ChefVault::Item.load("mysql","newUser")

template "/var/www/html/hello_world.php" do
  source "hello_world.php.erb"
  variables :username => db_user['username'], :password => db_user['password']
end
