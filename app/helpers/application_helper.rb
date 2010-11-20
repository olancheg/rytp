module ApplicationHelper
  def title
    "| "+content_for(:title) unless content_for(:title).empty?
  end

  def set_title(title)
    content_for :title, title
  end

  def active?(*actions)
    'active' if actions.to_a.include?(controller.action_name.to_s)
  end

  def page_feeds?(*pages)
    pages.include?(controller.action_name)
  end
end
