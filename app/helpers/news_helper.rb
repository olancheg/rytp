module NewsHelper
  def previous_new(new)
    news = news_ids
    news ? news_path(news.at((news.index(new.id)||0)-1)) : last_path
  end

  def next_new(new)
    news = news_ids

    if news
      pos = news.index(new.id)||0
      news_path news.at(pos == (news.count-1) ? 0 : pos+1)
    else
      last_path
    end
  end  
  
  def news_ids
    News.back_ordered.map(&:id)
  end
end
