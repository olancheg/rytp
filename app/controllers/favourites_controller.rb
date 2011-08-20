class FavouritesController < ApplicationController
  before_filter :require_authentication
  before_filter :find_poop

  def add
    if current_user.favourites.create(:poop => @poop).persisted?
      flash[:success] = t(:'favourites.added')
    else
      flash[:success] = t(:'favourites.failed')
    end

    respond_to do |format|
      format.html { redirect_to watch_path(@poop) }
      format.js { render 'shared/update_poop', :locals => {:poop => @poop}, :layout => false }
    end
  end

  def remove
    if current_user.favourites.find_by_poop_id(@poop).destroy
      flash[:success] = t(:'favourites.removed')
    else
      flash[:success] = t(:'favourites.failed')
    end

    respond_to do |format|
      format.html { redirect_to watch_path(@poop) }
      format.js { render 'shared/update_poop', :locals => {:poop => @poop}, :layout => false }
    end
  end

  private

  def find_poop
    @poop ||= Poop.find(params[:id])
  end
end
