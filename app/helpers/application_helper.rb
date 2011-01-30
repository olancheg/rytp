module ApplicationHelper
  def title
    content_for(:title) unless content_for(:title).empty?
  end

  def set_title(hash={})
    if hash[:title]
      content_for :title, [hash[:type] || 'RYTP', hash[:title]].join(' | ')
    else
      content_for :title, hash[:type] || 'RYTP'
    end
  end

  def active?(*actions)
    'active' if actions.to_a.include?(controller.action_name.to_s)
  end

  def admin?
    !session[:admin].nil?
  end

  def policeman?
    !session[:policeman].nil?
  end

  def main_admin?
    !session[:main].nil?
  end

  def with_brs(text)
    text = text.gsub "\n", "<br />" 
    sanitize text, :tags => %w{br}
  end
end
