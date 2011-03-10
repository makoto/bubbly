#! /usr/bin/ruby

require 'rubygems'
require 'open-uri'
require 'uri'
require 'json'

class Crawler
  attr_accessor :raw_html
  
  def initialize(option)
    @url = "http://search.twitter.com/search.json" 
    @initial_query = "?q=sxsw&show_user=true&rpp=100&page=1"
    @option = option
    @data = []
    @last_id =  `tail -1 #{@option[:outfile]}`.chomp.to_i
  end
  
  def crawl(query = @initial_query)
    response = JSON.parse(fetch(@url + query))
    @data = @data + response["results"].map do |r|
      # p r["created_at"]
      # p "#{r["id_str"].to_i.class} > #{@last_id}"
      r["id_str"]
    end.find_all{|r| r.to_i > @last_id} # removing duplicate
    oldest_id = response["results"][-1]["id_str"].to_i
    newest_id = response["results"][0]["id_str"].to_i
    # recent first
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
    return false unless @option[:outfile]
    puts "#{Time.now}: saving #{@data.size} tweets"
    File.open(@option[:outfile], "a") do |f|
      @data.reverse.each do |d|
        f.puts d
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
  crawler = Crawler.new(:outfile => './data/tweets.txt')
  crawler.crawl
  crawler.save
end

