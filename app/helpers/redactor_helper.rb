module RedactorHelper
  def redactor_css
    content_for :stylesheets do
      stylesheet_link_tag '/redactor/css/redactor.css'
    end
  end

  def redactor(element)
    content_for :bottom_javascript do
      result =  javascript_include_tag '/redactor/redactor'
      result += content_tag :script, "$(function() { $('#{element}').redactor(redactor); });", :type => "text/javascript"
      result
    end
  end
end
