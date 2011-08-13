module FeedHelper
  def author(name)
    if name
      t(:feed_by) + ' ' + name.to_s
    else
      ''
    end
  end

  def rfc_url(path)
    'http://rytp.ru' + path.gsub(/&/, '&amp;')
  end
end
