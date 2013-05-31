# Debian 系と redhat 系の分岐が必要だけど...
package "tcl8.5" do
  action :install
end

# 作業用ディレクトリの作成
directory "/usr/local/src/redis" do
  action :create
  not_if "ls -d /usr/local/src/redis"
end

# 最新のソースコードを取得
remote_file "/usr/local/src/redis/redis-2.6.13.tar.gz" do
  source "http://redis.googlecode.com/files/redis-2.6.13.tar.gz"
  not_if "ls /usr/local/bin/redis-server"
end

# ソースコードのアーカイブを展開して make && make test && make install
bash "install_redis_program" do
  user "root"
  cwd "/usr/local/src/redis/"
  code <<-EOH
    tar -zxf redis-2.6.13.tar.gz
    (cd redis-2.6.13/ && make test && make && make install)
  EOH
  not_if "ls /usr/local/bin/redis-server"
end

# サービスを起動する
bash "start_redis_server" do
  user "root"
  cwd "/usr/local/bin"
  code <<-EOH
    /usr/local/bin/redis-server &
  EOH
  not_if "ps aux | grep \[r\]edis-server"
end
