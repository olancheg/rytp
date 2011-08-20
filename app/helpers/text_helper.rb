module TextHelper
  def errors_count(count)
    count.to_s + ' ' + t(:error, :count => count) + ':'
  end

  def empty
    content_tag :div, t(:empty), :class => :empty
  end

  def with_brs(text)
    text = text.gsub "\n", "<br />"
    sanitize text, :tags => %w{br}
  end

  def short_date(date)
    Russian::strftime date, '%d %B %Y'
  end

  def redactor(element)
    content_for :bottom_javascript do
      content_tag :script, "$(function() { $('#{element}').redactor(redactor); });", :type => "text/javascript"
    end
  end
end
