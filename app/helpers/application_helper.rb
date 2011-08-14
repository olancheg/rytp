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

  def link_to_active(title, path, options={})
    link_to title, path, :class => [options[:class], ('active' if current_page?(path))].join(' ')
  end

  def comments_link(poop)
    path = classes = ''

    if (request.xhr? and (request.referer !~ /[^=]\d+(#.*)?$/ or request.referer !~ /users/)) or (!request.xhr? and !current_page?(watch_path poop))
      path = watch_path(poop)
    else
      classes = 'comments_button'
    end

    link_to path + '#comments', :class => ['button', classes].join(' ') do
      content_tag(:span, '', :class => 'comment icon') + t(:comments)
    end
  end

  def arrow(sort_by)
    if params[:order] == 'desc' or params[:sort_by] != sort_by.to_s
      t(:arrow_down)
    else
      t(:arrow_up)
    end + ' '
  end

  def link_to_sort(text, sort_by, options={})
    link_to url_for(:approved => params[:approved], :sort_by => sort_by, :page => params[:page],
                    :order => (params[:order] == 'asc' || (params[:order_by] and params[:order_by] != 'rating') ? 'desc' : 'asc')), options do
      arrow(sort_by) + text
    end
  end
end
