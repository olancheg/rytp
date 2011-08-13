class VotesController < ApplicationController
  before_filter :require_authentication
  before_filter :find_poop

  def positive
    if current_user.positive_votes.create(:poop => @poop).persisted?
      flash[:success] = t(:'voting.success')
    else
      flash[:error] = t(:'voting.failure')
    end

    respond_to do |format|
      format.html { redirect_to watch_path(@poop) }
      format.js { render 'shared/update_poop', :locals => {:poop => @poop}, :layout => false }
    end
  end

  def negative
    if current_user.negative_votes.create(:poop => @poop).persisted?
      flash[:success] = t(:'voting.success')
    else
      flash[:error] = t(:'voting.failure')
    end

    respond_to do |format|
      format.html { redirect_to watch_path(@poop) }
      format.js { render 'shared/update_poop', :locals => {:poop => @poop}, :layout => false }
    end
  end

  private

  def find_poop
    @poop = Poop.find(params[:id])
  end
end
