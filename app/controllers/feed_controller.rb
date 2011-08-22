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

    @users = User.all
    @user_pages = []

    @users.each do |user|
      @user_pages[user.id] = {}
      %w{approved favourites contest}.each do |filter|
        @user_pages[user.id][filter] = pages_count user.filters_and_orders({:filter => filter}).count, Poop
      end
    end

    @top = {}
    [:RYTP, :RYTPMV].each do |category|
      @top[category] = {}
      [nil, 'by_month', 'all_time'].each do |period|
        @top[category][period] = Poop.top_by_category_and_period(category, period).to_a
      end
    end

    @contests = Contest.active
    @contests_pages = pages_count @contests.count, Contest

    @contest = []
    @contests.each do |contest|
      @contest[contest.id] = pages_count contest.approved_poops.count, Poop
    end

    @rytps = @poops.by_category(:RYTP)
    @last_rytp = @rytps.last
    @rytpmvs = @poops.by_category(:RYTPMV)
    @last_rytpmv = @rytpmvs.last

    @feed = { :RYTP => {}, :RYTPMV => {} }
    @feed[:RYTP][:poops] = @rytps
    @feed[:RYTP][:pages] = pages_count @rytps.count, Poop
    @feed[:RYTPMV][:poops] = @rytpmvs
    @feed[:RYTPMV][:pages] = pages_count @rytpmvs.count, Poop

    @news = News.all
    @news_pages = pages_count @news.count, News

    respond_to do |format|
      format.xml
    end
  end

  private

  def pages_count(count, model)
    (count / model::PAGINATES_PER.to_f).ceil
  end
end
