class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :init_cookies

  def authenticate
    redirect_to login_path if session[:admin].nil?
  end

  def only_main
    user = Admin.find_by_id(session[:admin]) if session[:admin]
    if !(user and user.main)
      redirect_to root_path
    end
  end

  def init_cookies
    cookies[:votes]={ :value => "0", :expires => Time.now + 24*7*4*3600 } if cookies[:votes].nil?
  end

  def voted?(poop)
    poop.to_s.scan(/(#{cookies[:votes]})/).length > 0
  end
end
