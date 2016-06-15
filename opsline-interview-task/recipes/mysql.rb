
# Chef Gem throws a warning in Chef 12.1+. The following is a workaround.

chef_gem "chef-vault" do
  compile_time false if respond_to?(:compile_time)
end

include_recipe 'chef-vault'

password = ChefVault::Item.load("mysql","initial_root_password")

mysql_service 'opsline-interview' do
  port '3306'
  bind_address '0.0.0.0'
  initial_root_password password['initial_root_password']
  action [:create, :start]
end

# Add a user via a databag item.

new_user = ChefVault::Item.load("mysql","newUser")

execute "grant_mysql_privilages" do
  command "mysql -S /var/run/mysql-opsline-interview/mysqld.sock -e \"GRANT ALL ON *.* TO \'#{new_user['username']}\'@\'localhost\' IDENTIFIED BY \'#{new_user['password']}\'\" -u root --password='#{password['initial_root_password']}'"
  action :run
end

execute "flush_mysql_privilages" do
  command "mysql -S /var/run/mysql-opsline-interview/mysqld.sock -e \"FLUSH PRIVILEGES\" -u root --password='#{password['initial_root_password']}'"
  action :run
end
