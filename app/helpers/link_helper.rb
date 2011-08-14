module LinkHelper
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
