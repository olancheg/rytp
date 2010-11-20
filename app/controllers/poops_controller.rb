class PoopsController < ApplicationController
  def index
    @poops = Poop.by_category('RYTP')

    respond_to do |format|
      format.html
      format.xml  { render :xml => @poops }
      format.rss { render :layout => false }
    end
  end

  def rytpmv
    @poops = Poop.by_category('RYTPMV')

    respond_to do |format|
      format.html { render :template => 'poops/index' }
      format.xml  { render :xml => @poops }
    end
  end

  def top
    @poops = Poop.by_category(params[:category] || 'RYTP')
  end

  def show
    @poop = Poop.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @poop }
    end
  end

  def new
    @poop = Poop.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @poop }
    end
  end

  def edit
    @poop = Poop.find(params[:id])
  end

  def create
    @poop = Poop.new(params[:poop])

    respond_to do |format|
      if @poop.save
        format.html { redirect_to(@poop, :notice => 'Poop was successfully created.') }
        format.xml  { render :xml => @poop, :status => :created, :location => @poop }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @poop.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @poop = Poop.find(params[:id])

    respond_to do |format|
      if @poop.update_attributes(params[:poop])
        format.html { redirect_to(@poop, :notice => 'Poop was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @poop.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @poop = Poop.find(params[:id])
    @poop.destroy

    respond_to do |format|
      format.html { redirect_to(poops_url) }
      format.xml  { head :ok }
    end
  end
end
