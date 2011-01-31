require 'hpricot'
require 'digest'

class PoopsController < ApplicationController
  before_filter :admin_or_policeman?, :only => [ :edit, :update ]
  before_filter :admin?, :only => :destroy
  before_filter :hacker?, :only => [ :vote, :vote_bad ]

  def index
    poop = Poop.by_category('RYTP').approved.last

    if poop
      redirect_to watch_path(poop), :status => :found
    else
      render :template => 'poops/index'
    end
  end

  def search
    @poops = Poop.search(params[:search])
  end

  def rytpmv
    poop = Poop.by_category('RYTPMV').approved.last

    if poop
      redirect_to watch_path poop
    else
      render :template => 'poops/index'
    end
  end

  def top
    @poops = Poop.popular.by_category(params[:category] || 'RYTP').limit(50).paginate(:per_page => 5, :page => params[:page])
  end

  def vote
    unless voted?(params[:id])
      @poop = Poop.find_by_id(params[:id])
      redirect_to root_path unless @poop

      @poop.rate+=1
      @poop.votes_count+=1 unless voted?(params[:id]) or voted_bad?(params[:id])
      @poop.save

      unvote(@poop.id, :bad)
      vote_for(@poop.id, :good)
    end
  end

  def vote_bad
    unless voted_bad?(params[:id])
      @poop = Poop.find_by_id(params[:id])
      redirect_to root_path unless @poop

      @poop.rate-=1
      @poop.votes_count+=1 unless voted?(params[:id]) or voted_bad?(params[:id])
      @poop.save

      unvote(@poop.id, :good)
      vote_for(@poop.id, :bad)
    end
  end

  def show
    @poop = Poop.find_by_id(params[:id])
    redirect_to root_path unless @poop and (@poop.is_approved or !session[:admin].nil?)
  end

  def new
    @poop = Poop.new
  end

  def edit
    @poop = Poop.find_by_id(params[:id])
  end

  def create
    @poop = Poop.new(params[:poop])
    @poop.is_approved = false

    unless @poop.code.empty?
      code = Hpricot.parse @poop.code
      iframes = (code/"iframe")
      src = iframes.first[:src]
    end

    if src.nil? or (src =~ /^http\:\/\/(www\.)?(vk\.ru|vkontakte\.ru|youtube\.com|vimeo\.com)/ and iframes.size == 1)
      @poop.code = code.to_html unless @poop.code.empty?

      if @poop.save
        flash[:notice]="Ваш пуп добавлен. Он появится после проверки администратором."
        redirect_to add_poop_path
      else
        render :action => "new"
      end

    else
      flash[:notice] = "Некорректный код видео."
      render :action => "new"
    end

  rescue
    flash[:notice] = "Некорректный код видео."
    render :action => "new"
  end

  def update
    @poop = Poop.find_by_id(params[:id])

    if @poop.update_attributes(params[:poop])
      @poop.code = Hpricot(@poop.code).to_html
      @poop.save
      redirect_to watch_path(@poop)
    else
      render :action => "edit"
    end
  end

  def destroy
    @poop = Poop.find_by_id(params[:id])
    @poop.destroy

    if request.referer
      redirect_to :back
    else
      redirect_to @poop.category.name == 'RYTP' ? root_path : rytpmv_path
    end

  rescue
    redirect_to root_path
  end

private

  def hacker?
    logger.debug salt.to_s
    logger.debug "#{request.remote_ip}; #{request.env['HTTP_REFERER']}"
    if request.env['HTTP_REFERER'].nil? or !(request.env['HTTP_REFERER'] =~ /^http:\/\/(www\.)?#{request.host}/) or
      cookies[:good].empty? or cookies[:bad].empty? or params[:salt].nil? or salt != params[:salt]

      redirect_to '/error_404'
    end
  end

  def salt
    Digest::MD5.hexdigest "#{request.remote_ip}_#{request.env['HTTP_REFERER']}"
  end
end
