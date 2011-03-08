last = a.css('.interactive-listing-container').children.map do |b| 
   matrix = []
   counter = -1
   b.css('.meta').children.map do |m|
     if m.name == "strong"
       counter = counter + 1
       matrix[counter] = [m.text]
     else
      case matrix[counter][0]
      when "Time"
        if m.css('.value-title')
          m.css('.value-title').each do |n|
            matrix[counter].push(n.attr("title"))
          end
        end
      when "Speakers"
        if m.name == "a"
          matrix[counter].push("name : #{m.text}")
          matrix[counter].push("twitter : #{m.attr("href").gsub(/\//, "@")}") 
        end
      else
        matrix[counter].push("#{m.text}")
      end
     end
   end
   # matrix.each do |m|
   #   p m
   # end
   {
     :title => b.css('h3').text,
     :meta => matrix
   }
end.reject{|b| b[:title] == ""}.last

