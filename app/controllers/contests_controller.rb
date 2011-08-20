class ContestsController < ApplicationController
  before_filter :require_authentication, :except => [:index, :show]
  before_filter :find_contest

  authorize_resource

  def index
    @contests = if cannot?(:manage, Contest)
      Contest.active
    else
      Contest.scoped
    end.page params[:page]
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @contest.save
      redirect_to @contest, :notice => 'Contest was successfully created.'
    else
      render :new
    end
  end

  def update
    if @contest.update_attributes(params[:contest])
      redirect_to @contest, :notice => 'Contest was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @contest.destroy
  end

  private

  def find_contest
    @contest ||= if params[:id]
      Contest.find(params[:id])
    else
      Contest.new(params[:contest])
    end
  end
end
