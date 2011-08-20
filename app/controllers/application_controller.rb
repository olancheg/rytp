class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all

  rescue_from ActionController::RedirectBackError, :with => :redirect_to_root
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  rescue_from CanCan::AccessDenied, :with => :access_denied

protected

  def last_new
    @last_new ||= News.fetch_last
  end
  helper_method :last_new

  def last_contest
    @last_contest ||= Contest.fetch_last
  end
  helper_method :last_contest

  def last_poop
    @last_poop ||= Poop.fetch_last
  end
  helper_method :last_poop

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def current_user=(user)
    @current_user = user
    # if user is 'nil', it means that we logging him out
    session[:user_id] = user.nil? ? nil : user.id
  end

  def signed_in?
    !!current_user
  end
  helper_method :signed_in?

  def require_authentication
    unless current_user
      flash[:error] = t(:must_login)
      if request.xhr?
        render 'shared/_update_flash', :layout => false
      else
        redirect_to_back_or_root
      end
    end
  end

  def redirect_to_back_or(path)
    redirect_to (request.referer == '/' or flash[:deleted]) ? path : :back
  end

  def redirect_to_root
    redirect_to watch_path(last_poop)
  end

  def redirect_to_back_or_root
    redirect_to_back_or watch_path(last_poop)
  end

  def render_404
    flash[:page_not_found] = t(:page_not_found)
    redirect_to_back_or_root
  end

  def access_denied
    flash[:access_denied] = t(:access_denied)
    redirect_to_root
  end

  def set_feed_class
    @feed_class = 'list_layout'
  end

  def poops_from_category(category_id)
    @poops_from_category ||= Poop.poops_from_category(category_id)
  end
  helper_method :poops_from_category
end
