How to deploy:
==================

* ssh .......
* cd .......
* sudo git pull
* bundle
* sudo rm pids/unicorn.pid
* ps aux | grep 'unicorn master'
* sudo kill -QUIT [master pid] && sudo unicorn -c unicorn.rb -D
* sudo mongo
* use funders
* db.ids.insert({test: "test"})
* show collections

```
  ids
  system.indexes
```

* sudo ./update_funders.sh
* whenever -w


How to setup clean server (Debian 7.5)
======================================
```
sudo apt-get update && sudo apt-get upgrade
```

```
sudo apt-get -y install mongodb
```

```
sudo apt-get -y install build-essential zlib1g-dev git-core sqlite3 libsqlite3-dev vim
```

## openssl
```
sudo apt-get -y install build-essential autoconf libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev
```

## curb
```
sudo apt-get -y install libcurl4-openssl-dev
```

```
sudo apt-get -y install ruby

gem install bundler --no-rdoc --no-ri
```

## nginx
```
sudo apt-get -y install nginx
sudo rm /etc/nginx/sites-enabled/default
```

## rbenv
```
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
type rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

rbenv install 2.1.1

```

## Funder IDS

```
sudo mkdir /var/www
sudo chown -R vagrant /var/www
cd /var/www
git clone https://github.com/sergey-alekseev/Funder-IDS

```
