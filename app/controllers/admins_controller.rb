class AdminsController < ApplicationController
  before_filter :main_admin?, :except => [ :login, :logout, :not_approved ] 
  before_filter :admin?, :only => :not_approved

  def login
    if session[:admin]
      redirect_to root_path
    else
      if request.post?
        user = Admin.find_by_login(params[:login])
        if user and user.password == params[:password]
          session[:admin] = user.id
          redirect_to root_path
        else
          flash[:notice] = "Неправильная связка логин-пароль"
        end
      end
    end
  end

  def logout
    session[:admin] = nil
    redirect_to root_path
  end

  def not_approved
    @poops = Poop.not_approved.ordered.paginate(:per_page => 10, :page => params[:page])
  end

  def index
    @admins = Admin.all
  end

  def approve
    @poop = Poop.find_by_id(params[:id])
    @poop.is_approved = true
    @poop.save
    @poops = Poop.not_approved.ordered.paginate(:per_page => 5, :page => params[:page])

    if request.xhr?
      render :update do |page|
        unless @poops.empty?
          page.replace_html 'not_approved_poops', render(:partial => 'poops/poop', :collection => @poops)
        else
          page.replace_html 'not_approved_poops', 'Нет ни одного видео.'
        end

        page.replace_html 'navigation', will_paginate(@poops)
      end
    else
      redirect_to not_approved_path
    end
  end

  def show
    @admin = Admin.find(params[:id])
  end

  def new
    @admin = Admin.new
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def create
    @admin = Admin.new(params[:admin])

    if @admin.save
      redirect_to(@admin, :notice => 'Admin was successfully created.') 
    else
      render :action => "new"
    end
  end

  def update
    @admin = Admin.find(params[:id])

    if @admin.update_attributes(params[:admin])
      redirect_to(@admin, :notice => 'Admin was successfully updated.') 
    else
      render :action => "edit"
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy

    redirect_to(admins_url) 
  end
end
