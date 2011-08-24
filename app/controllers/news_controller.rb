class NewsController < ApplicationController
  before_filter :require_authentication, :except => [:index, :show]

  authorize_resource

  def index
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    news = current_user.news.build(params[:news])

    if news.save
      redirect_to news, :notice => t(:'news.created')
    else
      render :new
    end
  end

  def update
    if news.update_attributes(params[:news])
      redirect_to news, :notice => t(:'news.updated')
    else
      render :edit
    end
  end

  def destroy
    news.destroy

    redirect_to news_index_path
  end

  private

  def news
    @news ||= if params[:id]
      News.find(params[:id])
    else
      News.new(params[:news])
    end
  end
  helper_method :news

  def all_news
    @all_news ||= News.ordered.page params[:page]
  end
  helper_method :all_news
end

