class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :init_cookies

  def admin?
    redirect_to root_path if session[:admin].nil?
  end

  def policeman?
    redirect_to root_path if session[:policeman].nil?
  end

  def main_admin?
    redirect_to root_path if session[:main].nil?
  end

  def admin_or_policeman?
    redirect_to root_path if session[:policeman].nil? and session[:admin].nil?
  end

  def init_cookies
    cookies.permanent[:good] = cookies[:good] || Marshal.dump([])
    cookies.permanent[:bad]  = cookies[:bad]  || Marshal.dump([])
  end

  def unvote(poop, storage)
    remove_from_storage(poop, storage)
  end

  def vote_for(poop, storage)
    add_to_storage(poop, storage)
  end

  def voted?(poop)
    element_in_storage(poop.to_i, :good)
  end

  def voted_bad?(poop)
    element_in_storage(poop.to_i, :bad)
  end

  def element_in_storage(element, storage)
    array = Marshal.load(cookies[storage])
    array.include?(element)
  end

  def add_to_storage(element, storage)
    array = Marshal.load(cookies[storage])
    array << element
    cookies.permanent[storage] = Marshal.dump(array)
  end

  def remove_from_storage(element, storage)
    array = Marshal.load(cookies[storage])
    array.delete element
    cookies.permanent[storage] = Marshal.dump(array)
  end
end
