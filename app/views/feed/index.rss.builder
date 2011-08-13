xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", :'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "RYTP"
    xml.description "Все видео можно найти на http://rytp.ru"
    xml.link root_url
    xml.tag! 'atom:link', :href => "http://rytp.ru/feed.rss", :rel => "self", :type => "application/rss+xml"

    for poop in @poops
      xml.item do
        xml.title poop.title + ' | ' + poop.category.name + ' ' + author(poop.user)
        xml.description poop.description
        xml.pubDate poop.created_at.to_s(:rfc822)
        xml.link watch_url(poop)
        xml.guid watch_url(poop)
      end
    end
  end
end
