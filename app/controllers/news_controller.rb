class NewsController < ApplicationController
  before_filter :admin?, :except => [:show, :last]

  def index
    @news = News.all
  end

  def last
    @new = News.last

    redirect_to @new if @new
  end

  def show
    @news = News.find(params[:id])
  rescue
    redirect_to root_path
  end

  def new
    @news = News.new
  end

  def edit
    @news = News.find(params[:id])
  end

  def create
    @news = News.new(params[:news])

      if @news.save
        redirect_to(@news, :notice => 'New was successfully created.')
      else
        render :action => "new"
      end
  end

  def update
    @news = News.find(params[:id])

    if @news.update_attributes(params[:news])
      redirect_to(@news, :notice => 'New was successfully updated.')
    else
      render :action => "edit" 
    end
  end

  def destroy
    @news = News.find(params[:id])
    @news.destroy

    redirect_to(news_index_url) 
  end
end
