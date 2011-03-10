# Bubbly (may change name)

## How I did setup on ec2
### search api crawler
yum install rubygems
gem update --system
yum install  ruby-devel
yum install  git
gem install json
gem install bundler

Add cron
* * * * * cd ~/bubbly/twitter/search && ./crawler.rb >> ~/bubbly/twitter/search/log/crawler.log 2>&1

Start up god
