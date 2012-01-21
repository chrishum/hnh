class PartiesController < ApplicationController
  
  before_filter :require_user,  :only => [:new, :create, :edit, :update, :destroy]
  before_filter :require_admin, :only => [:new, :create, :edit, :update, :destroy]
  
  def index
    @title = "Parties"
    @parties = Party.paginate(:page => params[:page])
  end
  
  def show
    @party = Party.find(params[:id])
    @perps = @party.perps.paginate(:page => params[:page], :per_page => 10)
    @title = @party.name
  end
  
  def new
    @party = Party.new
    @title = "New Party"
  end
  
  def create
    @party = Party.new(params[:party])
    if @party.save
      redirect_to @party
    else
      @title = "New Party"
      render 'new'
    end
  end
  
  def edit
    @party = Party.find(params[:id])
    @title = "Edit party"
  end
  
  def update
    @party = Party.find(params[:id])
    if @party.update_attributes(params[:party])
      flash[:success] = "Party updated."
      redirect_to @party
    else
      @title = "Edit party"
      render 'edit'
    end
  end
  
  def destroy
    Party.find(params[:id]).destroy
    flash[:success] = "Party destroyed."
    redirect_to parties_path
  end
end
