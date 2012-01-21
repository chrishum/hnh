class StatementsController < ApplicationController
  
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy]
  
  def index
    @title = "Statements"
    @statements = Statement.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @statement = Statement.find(params[:id])
    @title = @statement.perp_name
  end
  
  def new
  end
  
  def create
    @perp = Perp.find_by_id(params[:perp])
    @statement = @perp.statements.build(params[:statement])
    if @statement.save
      flash[:success] = "Statement created!"
    end
    redirect_to perp_path(@perp)
  end
  
  def destroy
  end

end
