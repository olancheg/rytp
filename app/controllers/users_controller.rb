class UsersController < ApplicationController
  before_filter :require_authentication, :except => :show
  before_filter :set_feed_class, :only => :show
  before_filter :find_user, :except => :show

  def update
    if @user.update_attributes(params[:user])
      redirect_to profile_path(current_user), :notice => t(:'user.updated')
    else
      render :edit
    end
  end

  def edit
  end

  def show
    @user = User.find(params[:id])
    @poops = @user.filters_and_orders(params).page params[:page]

    respond_to do |format|
      format.html
      format.js { render :layout => false, :locals => {:poops => @poops} }
    end
  end

  private

  def get_user
    @user ||= current_user
  end
end
