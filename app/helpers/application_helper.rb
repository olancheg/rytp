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
end
