class PoopsController < ApplicationController
  before_filter :require_authentication, :except => [:index, :search, :top, :rytpmv, :show]
  before_filter :find_poop, :except => [:index, :rytpmv, :not_approved, :top, :search]
  before_filter :set_feed_class, :only => [:top, :search, :not_approved]

  authorize_resource

  def index
    redirect_to watch_path(last_poop), :status => :found if last_poop
  end

  def rytpmv
    poop = Poop.by_category('RYTPMV').approved.last

    if poop
      redirect_to watch_path(poop), :status => :found
    else
      render 'poops/index'
    end
  end

  def not_approved
    @poops = Poop.not_approved.ordered.page params[:page]

    respond_to do |format|
      format.html
      format.js { render 'shared/update_page', :layout => false, :locals => {:poops => @poops} }
    end
  end

  def approve
    @poop.approved = true

    flash[:success] = t(:'poop.approve') if @poop.save

    @poops = Poop.not_approved.ordered.page params[:page]

    respond_to do |format|
      format.html { redirect_to not_approved_path }
      format.js {
        if request.referer =~ /[^=]\d+\-[^\/]*$/
          render 'shared/update_poop', :layout => false, :locals => {:poop => @poop}
        else
          render 'shared/update_page', :layout => false, :locals => {:poops => @poops, :ajax => true}
        end
      }
    end
  end

  def search
    @poops = Poop.search(params[:search]).page params[:page]

    respond_to do |format|
      format.html
      format.js { render 'shared/update_page', :layout => false, :locals => {:poops => @poops} }
    end
  end

  def top
    @poops = Poop.top(params[:category], params[:period], params[:page])

    respond_to do |format|
      format.html
      format.js { render 'shared/update_page', :layout => false, :locals => {:poops => @poops} }
    end
  end

  def show
    render_404 unless @poop.approved? or (current_user and current_user.has_role?(:admin))
  end

  def new
  end

  def edit
  end

  def create
    @poop = current_user.poops.build
    @poop.accessible = :all if can?(:manage, @poop)
    @poop.attributes = params[:poop]

    if @poop.save
      redirect_to watch_path(last_poop), :notice => t(:'poop.added')
    else
      render :new
    end
  end

  def update
    @poop.accessible = :all if can?(:manage, @poop)

    if @poop.update_attributes(params[:poop])
      redirect_to watch_path(@poop)
    else
      render :edit
    end
  end

  def destroy
    flash[:deleted] = t(:'poop.deleted') if @poop.destroy

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js { render :text => "window.location.reload();" }
    end
  end

  private

  def find_poop
    @poop ||= if params[:id]
      Poop.find(params[:id])
    else
      Poop.new(params[:poop])
    end
  end
end
