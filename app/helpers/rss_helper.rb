module RssHelper
  def author(name)
    unless name.empty?
      'by '+name.to_s
    else
      ''
    end
  end
end
