

## How I did setup on ec2
### search api crawler
yum install rubygems
yum install  ruby-devel
yum install  git
gem install json

Add cron
* * * * * cd /home/ec2-user/sxsw/twitter/search && ./crawler.rb >> /home/ec2-user/sxsw/twitter/search/log/crawler.log 2>&1

