class FeedController < ApplicationController
  def index
    @poops = Poop.ordered.approved.limit(20)

    respond_to do |format|
      format.html { redirect_to poops_feed_path(:RYTP) }
      format.rss 
    end
  end

  def poops
    @poops = Poop.ordered.approved.by_category(params[:category] || 'RYTP').paginate(:per_page => 5, :page => params[:page])
  end
end
