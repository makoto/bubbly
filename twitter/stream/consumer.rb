!#/usr/bin/ruby
require "rubygems"
require "bundler/setup"
require 'yaml'
require 'json'
require 'eventmachine'
require 'em-http'

# require 'tweetstream'

ROOT_DIR = File.dirname(__FILE__)
keyword = ARGV[0]
p ARGV[0]
config = YAML.load_file(ROOT_DIR + '/config/config.yml')
p ROOT_DIR
p ROOT_DIR + '/config/config.yml'
outfile = (ROOT_DIR + "/data/#{keyword}.txt")

# mwc11
@f = File.new(outfile, "a") 
url = "http://stream.twitter.com/1/statuses/filter.json?track=#{keyword}"
counter = 0
EventMachine.run do
 http = EventMachine::HttpRequest.new(url).get :head => { 'Authorization' => [ config[:account], config[:password] ] }
 buffer = ""
 http.stream do |chunk|
   buffer += chunk
   while line = buffer.slice!(/.+\r?\n/)
    # p line
    counter = counter + 1
    p counter
    @f.puts line
   end
 end
end

@f.puts "begins"

# loop do
#   sleep 0.1
#   p "world"
#   @f.puts Time.now
#   p @f.class
# end

# Not working for 1.8.7 and can not use 
# TweetStream::Client.new(config[:account], config[:password]).track(keyword) do |status|
#   puts "#{status.text}"
#   f.puts status.to_json
# end
