class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :init_cookies

  def admin?
    redirect_to login_path if session[:admin].nil?
  end

  def main_admin?
    user = Admin.find_by_id(session[:admin]) if session[:admin]

    redirect_to root_path unless user and user.main
  end

  def init_cookies
    cookies[:good] = { :value => cookies[:good] || Marshal.dump([]), :expires => Time.now + 24*7*4*3600 }
    cookies[:bad]  = { :value => cookies[:bad] || Marshal.dump([]), :expires => Time.now + 24*7*4*3600 }
  end

  def unvote(poop, storage)
    remove_from_storage(poop, storage)
  end

  def vote_for(poop, storage)
    add_to_storage(poop, storage)
  end

  def voted?(poop)
    element_in_storage(poop, :good)
  end

  def voted_bad?(poop)
    element_in_storage(poop, :bad)
  end

  def element_in_storage(element, storage)
    array = Marshal.load(cookies[storage])
    array.include?(element)
  end

  def add_to_storage(element, storage)
    array = Marshal.load(cookies[storage])
    array << element
    cookies[storage] = Marshal.dump(array)
  end

  def remove_from_storage(element, storage)
    array = Marshal.load(cookies[storage])
    array.delete element
    cookies[storage] = Marshal.dump(array)
  end
end
