class RssController < ApplicationController
  respond_to :rss

  def index
    @poops = Poop.ordered.approved.limit(20)
  end
end
