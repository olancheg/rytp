class ContestsController < ApplicationController
  before_filter :require_authentication, :except => [:index, :show]

  authorize_resource

  def index
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.js { render 'shared/update_page', :layout => false, :locals => { :poops => poops, :id => params[:id] } }
    end
  end

  def new
  end

  def edit
  end

  def create
    if contest.save
      redirect_to contest, :notice => t(:'contest.created')
    else
      render :new
    end
  end

  def update
    if contest.update_attributes(params[:contest])
      redirect_to contest, :notice => t(:'contest.updated')
    else
      render :edit
    end
  end

  def destroy
    contest.destroy

    redirect_to contests_path, :notice => t(:'contest.deleted')
  end

  private

  def contest
    @contest ||= if params[:id]
      Contest.find(params[:id])
    else
      Contest.new(params[:contest])
    end
  end
  helper_method :contest

  def contests
    @contests ||= if can?(:manage, Contest)
      Contest.scoped
    else
      Contest.active
    end.page params[:page]
  end
  helper_method :contests

  def poops
    return @poops if @poops

    @poops = Poop.unscoped do
      contest.poops.order('created_at DESC')
    end

    @poops = @poops.only_approved if cannot?(:reject, Poop)
    @poops = @poops.page params[:page]
  end
  helper_method :poops
end
