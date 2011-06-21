# coding: utf-8

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
        redirect_to @news, :notice => 'Новость успешно создана!'
      else
        render :new
      end
  end

  def update
    @news = News.find(params[:id])

    if @news.update_attributes(params[:news])
      redirect_to @news, :notice => 'Новость успешно обновлена!'
    else
      render :edit
    end
  end

  def destroy
    @news = News.find(params[:id])
    @news.destroy

    redirect_to news_index_url
  end
end

