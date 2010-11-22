class PoopsController < ApplicationController
  before_filter :authenticate, :only => [ :edit, :update, :destroy ]

  def index
    @poops = Poop.ordered.by_category('RYTP').approved.paginate(:per_page => 5, :page => params[:page])
  end

  def rytpmv
    @poops = Poop.ordered.by_category('RYTPMV').approved.paginate(:per_page => 5, :page => params[:page])

    render :template => 'poops/index'
  end

  def top
    @poops = Poop.popular.by_category(params[:category] || 'RYTP').limit(20)
  end

  def vote
    @poop = Poop.find(params[:id])

    unless voted?(@poop.id)
      @poop.rate+=1
      @poop.save
      cookies[:votes]="#{cookies[:votes]}|#{@poop.id}"
    end

    if request.xhr?
      render :update do |page|
        page.replace_html "votes_#{@poop.id}", @poop.rate
        page << "$('vote_btn_#{@poop.id}').replace('#{t :kosar}')"
      end
    else
      redirect_to @poop
    end
  end

  def show
    @poop = Poop.find_by_id(params[:id])
    redirect_to root_path unless @poop
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

    redirect_to :back
  end
end
