module ApplicationHelper
  def title
    content_for(:title) if content_for(:title).present?
  end

  def description
    content_for(:description).empty? ? t(:description) : content_for(:description)
  end

  def set_title(hash={})
    if hash[:title]
      content_for :title, [hash[:type] || 'RYTP', hash[:title]].join(' | ')
    else
      content_for :title, hash[:type] || 'RYTP'
    end
  end

  def set_description(text)
    content_for :description, text
  end
end
