class AdminsController < ApplicationController
  before_filter :main_admin?, :except => [ :login, :logout, :not_approved, :approve ]
  before_filter :admin_or_policeman?, :only => [ :not_approved, :approve ]
  
  expose(:admins) { Admin.all }
  expose(:admin)

  def login
    if session[:admin]
      redirect_to root_path
    else
      if request.post?
        user = Admin.find_by_login(params[:login].mb_chars.downcase)
        if user and user.password == params[:password]
          session[:admin] = user.id if !user.policeman
          session[:policeman] = 'yes' if user.policeman
          session[:main] = 'yes' if user.main
          redirect_to root_path
        else
          flash[:notice] = "Wrong login or password"
        end
      end
    end
  end

  def logout
    session[:admin] = session[:policeman] = session[:main] = nil

    redirect_to :back
  end

  def not_approved
    if request.xhr?
      @poop = Poop.find_by_id(params[:id])
      @poop.is_approved = true
      @poop.save
    end

    @poops = Poop.not_approved.ordered.paginate(:per_page => 5, :page => params[:page])
  end

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if admin.save
      redirect_to admin, :notice => 'Admin was successfully created.'
    else
      render :new
    end
  end

  def update
    if admin.update_attributes(params[:admin])
      redirect_to admin, :notice => 'Admin was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    admin.destroy

    redirect_to admins_url
  end
end

