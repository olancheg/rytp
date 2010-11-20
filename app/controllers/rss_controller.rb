class RssController < ApplicationController
  respond_to :rss

  def index
    @poops = Poop.ordered.limit(20)
  end
end
