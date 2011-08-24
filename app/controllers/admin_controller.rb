class AdminController < ApplicationController
  before_filter :require_authentication
  before_filter :admin?

  def index
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

  def show
  end

  def update
    user.accessible = :all

    if user.update_attributes(params[:user])
      flash[:success] = t(:'user.updated')

      redirect_to admin_path(user)
    else
      render :show
    end
  end

  def destroy
    user.destroy
    flash[:success] = t(:'user.deleted')
    redirect_to admin_index_path
  end

  def votes
    Vote.destroy user.vote_ids
    flash[:success] = t(:'user.deleted')
    redirect_to admin_path(user)
  end

  def poops
    Poop.destroy user.poop_ids
    flash[:success] = t(:'user.deleted')
    redirect_to admin_path(user)
  end

  private

  def admin?
    raise CanCan::AccessDenied unless current_user.has_role? :admin
  end

  def user
    @user ||= User.find(params[:id]) if params[:id]
  end
  helper_method :user

  def users
    @users ||= if params[:search].present?
      User.search(params[:search])
    else
      User.scoped
    end.page(params[:page])
  end
  helper_method :users
end
