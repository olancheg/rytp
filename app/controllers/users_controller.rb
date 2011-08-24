class UsersController < ApplicationController
  before_filter :require_authentication, :except => :show
  before_filter :set_feed_class, :only => :show

  def update
    if user.update_attributes(params[:user])
      redirect_to profile_path(user), :notice => t(:'user.updated')
    else
      render :edit
    end
  end

  def edit
  end

  def show
    respond_to do |format|
      format.html
      format.js { render :layout => false, :locals => {:poops => poops} }
    end
  end

  private

  def user
    @user ||= if action_name == 'show'
      User.find(params[:id])
    else
      current_user
    end
  end
  helper_method :user

  def poops
    @poops ||= user.filters_and_orders(params).page params[:page]
  end
  helper_method :poops
end
