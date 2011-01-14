class PoopsController < ApplicationController
  before_filter :admin?, :only => [ :edit, :update, :destroy ]

  def index
    poop = Poop.by_category('RYTP').approved.last

    if poop
      redirect_to watch_path poop
    else
      render :template => 'poops/index'
    end
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
    @poops = Poop.popular.by_category(params[:category] || 'RYTP').paginate(:per_page => 7, :page => params[:page])
  end

  def vote
    unless voted?(params[:id])
      @poop = Poop.find(params[:id])
      redirect_to root_path unless @poop

      @poop.rate+=1
      @poop.save

      unvote(@poop.id, :bad)
      vote_for(@poop.id, :good)

      if request.xhr?
        render :update do |page|
          page.replace_html "votes_#{@poop.id}", @poop.rate.to_s+' '+Russian.p(@poop.rate, "косарь", "косаря", "косарей")
          page.replace_html "vote_bad_btn_#{@poop.id}", link_to('ХУNТА', vote_bad_path(@poop), :remote => true)
          page.replace_html "vote_btn_#{@poop.id}", 'дать косарь'
        end
      else
        redirect_to @poop
      end
    end
  end

  def vote_bad
    unless voted_bad?(params[:id])
      @poop = Poop.find(params[:id])
      redirect_to root_path unless @poop

      @poop.rate-=1
      @poop.save

      unvote(@poop.id, :good)
      vote_for(@poop.id, :bad)

      if request.xhr?
        render :update do |page|
          page.replace_html "votes_#{@poop.id}", @poop.rate.to_s+' '+Russian.p(@poop.rate, "косарь", "косаря", "косарей")
          page.replace_html "vote_btn_#{@poop.id}", link_to('дать косарь', vote_poop_path(@poop), :remote => true)
          page.replace_html "vote_bad_btn_#{@poop.id}", 'ХУNТА'
        end
      else
        redirect_to @poop
      end
    end
  end

  def show
    @poop = Poop.find(params[:id])
    redirect_to root_path unless @poop
  end

  def new
    @poop = Poop.new
  end

  def edit
    @poop = Poop.find(params[:id])
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
    @poop = Poop.find(params[:id])

    if @poop.update_attributes(params[:poop])
      redirect_to watch_path(@poop)
    else
      render :action => "edit"
    end
  end

  def destroy
    @poop = Poop.find(params[:id])
    @poop.destroy

    redirect_to @poop.category.name == 'RYTP' ? root_path : rytpmv_path
  end
end
