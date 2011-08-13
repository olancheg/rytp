class NewsController < ApplicationController
  before_filter :require_authentication, :except => [:index, :show]
  before_filter :find_new
  authorize_resource

  def index
    @news = News.ordered.page params[:page]

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
    @news = current_user.news.build(params[:news])

    if @news.save
      redirect_to @news, :notice => t(:'news.created')
    else
      render :new
    end
  end

  def update
    if @news.update_attributes(params[:news])
      redirect_to @news, :notice => t(:'news.updated')
    else
      render :edit
    end
  end

  def destroy
    @news.destroy
    redirect_to_back_or news_index_path
  end

  private

  def find_new
    @news ||= if params[:id]
      News.find(params[:id])
    else
      News.new(params[:news])
    end
  end
end

