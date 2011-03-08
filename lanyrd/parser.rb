last = a.css('.interactive-listing-container').children.map do |b| 
   meta = {}
   counter = -1
   metakey = ""
   b.css('.meta').children.map do |m|
     if m.name == "strong"
       counter = counter + 1
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
          meta[metakey].push("name : #{m.text}")
          meta[metakey].push("twitter : #{m.attr("href").gsub(/\//, "@")}") 
        end
      else
        meta[metakey].push("#{m.text}")
      end
     end
   end
   # matrix.each do |m|
   #   p m
   # end
   {
     :title => b.css('h3').text,
     :meta => meta
   }
end.reject{|b| b[:title] == ""}.last

