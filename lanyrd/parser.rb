require 'nokogiri'
require 'pp'

data = []
(1..34).each do |n|
  a = Nokogiri::HTML(File.open("data/sxsw_#{n}.html").read)
  page_data = a.css('.interactive-listing-container').children.map do |b| 
     meta = {}
     metakey = ""
     b.css('.meta').children.map do |m|
       if m.name == "strong"
         metakey = m.text
         meta[metakey] = []
       else
        case metakey
        when "Time"
          if m.css('.value-title')
            m.css('.value-title').each do |n|
              meta[metakey].push(n.attr("title"))
            end
          end
        when "Speakers"
          if m.name == "a"
            hash = {:name => m.text, :twitter => m.attr("href").gsub(/\//, "@")}
            meta[metakey].push(hash) 
          end
        else
          meta[metakey].push("#{m.text}")
        end
       end
     end
     meta = meta.merge(meta) do|k,ov|
       ov = ov.join unless ["Time", "Speakers"].include?(k)
       ov
     end
     {
       :title => b.css('h3').text,
       :meta => meta
     }
  end.reject{|b| b[:title] == ""}
  data = data + page_data
end

puts data