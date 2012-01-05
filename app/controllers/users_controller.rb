class UsersController < ApplicationController
  
  before_filter :non_user,     :only => [:new, :create]
  before_filter :authenticate, :only => [:edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  before_filter :not_self,     :only => :destroy
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def new
    @user = User.new
    @title = "Register"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Hyp & Hype"
      redirect_to @user
    else
      @title = "Register"
      @user.password = ""
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "User destroyed."
    redirect_to root_path
  end
  
private
  
  def authenticate
    deny_access unless signed_in?
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
  
  def non_user
    redirect_to(root_path) unless !signed_in?
  end
  
  def not_self
    @user = User.find(params[:id])
    redirect_to(root_path) unless !current_user?(@user)
  end
end
