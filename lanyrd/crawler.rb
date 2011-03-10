require 'open-uri'
require 'uri'

class Crawler
  attr_accessor :raw_html
  
  def initialize(url, options = {})
    @options       = options
    @url           = URI.parse(url)
    @domain        = @url.host
    @path          = @url.path
    @keyword       = @options[:keyword] || 'holidayextras'
  end
  
  def crawl
    open(@url.to_s).read
  end
end

url = "http://sxsw.lanyrd.com/?page="
outdir = "data/"
(1..34).each do |n|
outfile =  "#{outdir}sxsw_#{n}.html"
 File.open(outfile, "a") do |f|
   f.puts Crawler.new("#{url}#{n}").crawl
 end
 p "feched #{url}#{n}"
 sleep 0.5
end