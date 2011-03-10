#! /usr/bin/ruby

require 'rubygems'
require 'open-uri'
require 'uri'
require 'json'

class Crawler
  attr_accessor :raw_html
  
  def initialize(file_name)
    @url = "http://search.twitter.com/search.json" 
    @initial_query = "?q=sxsw&show_user=true&rpp=100&page=1"
    @file_name = file_name
    @data = []
    @last_id = File.exist?(@file_name) ? JSON.parse(`tail -1 #{@file_name}`)["id_str"].to_i : 0
  end
  
  def crawl(query = @initial_query)
    response = JSON.parse(fetch(@url + query))
    
    # recent first
    @data = @data + response["results"].map do |r|
      # r["id_str"]
      r
    end.find_all{|r| r["id_str"].to_i > @last_id} # removing duplicate
    oldest_id = response["results"][-1]["id_str"].to_i
    newest_id = response["results"][0]["id_str"].to_i
    
    # response.each do |k, v|
    #   p "k: #{k} v : #{v}"
    # end

    page = response["page"].to_i
    sleep 1
    p [oldest_id, newest_id, page, query].join(", ")
    query = response["next_page"]
    crawl(query) if query && oldest_id > @last_id 
  end
  
  def save
    puts "#{Time.now}: saving #{@data.size} tweets"
    mode =  File.exist? @file_name ? "a" : "w"
    File.open(@file_name, "a") do |f|
      @data.reverse.each do |d|
        # puts JSON.generate(d)
        f.puts JSON.generate(d)
      end
    end
  end

private
  def fetch(query)
    url           = URI.parse(query)
    open(url.to_s).read
  end
end


  require 'pp'
 

# do_get(url, query)

if __FILE__ == $0
  crawler = Crawler.new('./data/tweets.txt')
  crawler.crawl
  crawler.save
end

