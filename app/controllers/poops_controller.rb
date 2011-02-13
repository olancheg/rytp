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
      redirect_to watch_path(poop)
    else
      render :template => 'poops/index'
    end
  end

  def top
    @poops = Poop.popular.by_category(params[:category] || 'RYTP').paginate(:per_page => 5, :page => params[:page])
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

    if @poop.save
      flash[:notice]="Ваш пуп добавлен. Он появится после проверки администратором."
      redirect_to add_poop_path
    else
      render :action => "new"
    end
  end

  def update
    @poop = Poop.find_by_id(params[:id])

    if @poop.update_attributes(params[:poop])
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
    render_404 if cookies[:good].empty? or cookies[:bad].empty? or params[:salt].nil? or salt != params[:salt] or !request.post?
  end

  def salt
    Digest::MD5.hexdigest "#{request.remote_ip}_#{request.env['HTTP_REFERER']}"
  end
end
