xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "RYTP"
    xml.description "Все видео можно найти на http://rytp.ru"
    xml.link root_url
    
    for poop in @poops
      xml.item do
        xml.title poop.title
        xml.description poop.description
        xml.pubDate poop.created_at.to_s(:rfc822)
        xml.link watch_url(poop)
        xml.guid watch_url(poop)
      end
    end
  end
end
