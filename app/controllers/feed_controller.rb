class FeedController < ApplicationController
  before_filter :set_feed_class, :only => :poops

  layout 'application', :only => :poops

  def index
    @poops = Poop.ordered.approved.limit(20)

    respond_to do |format|
      format.html { redirect_to poops_feed_path(:RYTP) }
      format.rss
    end
  end

  def poops
    @poops = Poop.feed(params[:category]).page params[:page]

    respond_to do |format|
      format.html
      format.js { render 'shared/update_page', :locals => {:poops => @poops} }
    end
  end

  def sitemap
    response.headers['Cache-Control'] = 'public, max-age=43200'

    @poops = Poop.approved.ordered

    @top = {}
    [:RYTP, :RYTPMV].each do |category|
      @top[category] = {}
      [nil, 'by_month', 'all_time'].each do |period|
        @top[category][period] = Poop.top_by_category_and_period(category, period)
      end
    end

    @rytps = @poops.by_category(:RYTP)
    @last_rytp = @rytps.last
    @rytpmvs = @poops.by_category(:RYTPMV)
    @last_rytpmv = @rytpmvs.last

    @feed = { :RYTP => {}, :RYTPMV => {} }
    @feed[:RYTP][:poops] = @rytps
    @feed[:RYTP][:pages] = (@rytps.count / Poop::PAGINATES_PER.to_f).ceil
    @feed[:RYTPMV][:poops] = @rytpmvs
    @feed[:RYTPMV][:pages] = (@rytpmvs.count / Poop::PAGINATES_PER.to_f).ceil

    @news = News.all
    @news_pages = (@news.count / News::PAGINATES_PER.to_f).ceil

    respond_to do |format|
      format.xml
    end
  end
end
