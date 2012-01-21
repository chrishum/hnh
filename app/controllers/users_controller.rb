class UsersController < ApplicationController
  before_filter :require_no_user,      :only => [:new, :create]
  before_filter :require_user,         :only => [:show, :edit, :update, :destroy]
  before_filter :require_correct_user, :only => [:edit, :update]
  before_filter :require_admin,        :only => [:destroy]
  
  def new
    @title = "Register"
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to Hyp & Hype!"
      redirect_back_or_default @user
    else
      @title = "Register"
      render :action => :new
    end
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.handle
  end

  def edit
    @title = "Edit user"
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Account updated!"
      redirect_to @user
    else
      @title = "Edit user"
      render :action => :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    unless current_user?(@user)
      @user.destroy
      flash[:success] = "User destroyed."
      redirect_to root_path
    else
      redirect_to users_path
    end
  end
  
private
  
  def require_correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
#  before_filter :non_user,     :only => [:new, :create]
#  before_filter :authenticate, :only => [:edit, :update, :destroy]
#  before_filter :correct_user, :only => [:edit, :update]
#  before_filter :admin_user,   :only => :destroy
#  before_filter :not_self,     :only => :destroy
  
#  def show
#    @user = User.find(params[:id])
#    @title = @user.name
#  end
  
#  def new
#    @user = User.new
#    @title = "Register"
#  end
  
#  def create
#    @user = User.new(params[:user])
#    if @user.save
#      sign_in @user
#      flash[:success] = "Welcome to Hyp & Hype"
#      redirect_to @user
#    else
#      @title = "Register"
#      @user.password = ""
#      render 'new'
#    end
#  end
  
#  def edit
#    @title = "Edit user"
#  end
  
#  def update
#    if @user.update_attributes(params[:user])
#      flash[:success] = "Profile updated."
#      redirect_to @user
#    else
#      @title = "Edit user"
#      render 'edit'
#    end
#  end
  
#  def destroy
#    @user.destroy
#    flash[:success] = "User destroyed."
#    redirect_to root_path
#  end
  
#private
  
#  def correct_user
#    @user = User.find(params[:id])
#    redirect_to(root_path) unless current_user?(@user)
#  end
   
#  def non_user
#    redirect_to(root_path) unless !signed_in?
#  end
  
#  def not_self
#    @user = User.find(params[:id])
#    redirect_to(root_path) unless !current_user?(@user)
#  end
end
