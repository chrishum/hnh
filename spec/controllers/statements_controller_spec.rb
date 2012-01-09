require 'spec_helper'

describe StatementsController do
  render_views
  
  describe "access control" do
    
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end
  
  describe "GET 'index'" do
    
    before(:each) do
      @statements = []
      30.times do
        @statements << Factory(:statement)
      end
      first  = Factory(:statement, :content => "First")
      second = Factory(:statement, :content => "Second")
      third  = Factory(:statement, :content => "Third")
      @statements << first
      @statements << second
      @statements << third
    end
    
    it "should be successful" do
      get :index
      response.should be_success
    end
    
    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "Statements")
    end
    
    it "should have an element for each statement" do
      get :index
      @statements[0..2].each do |statement|
        response.should have_selector("span", :content => statement.content)
      end
    end
    
    it "should paginate statements" do
      get :index
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a", :href => "/statements?page=2",
                                         :content => "2")
      response.should have_selector("a", :href => "/statements?page=2", 
                                         :content => "Next")
    end
    
    describe "as a non-admin user" do
      it "should not have 'delete' links" do
        get :index
        response.should_not have_selector("a", :content => "delete")
      end
    end
    
    describe "as an admin user" do
      it "should have 'delete' links" do
        test_sign_in(Factory(:user, :email => "admin@user.com", :admin => true))
        get :index
        response.should have_selector("a", :content => "delete")
      end
    end
  end

  describe "POST 'create'" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
      @perp = Factory(:perp)
    end
    
    describe "failure" do
      
      before(:each) do
        @attr = { :content => "" }
      end
      
      it "should not create a statement" do
        lambda do
          post :create, :statement => @attr, :perp => @perp
        end.should_not change(Statement, :count)
      end
      
      it "should render the perp page" do
        post :create, :statement => @attr, :perp => @perp
        response.should redirect_to(perp_path(@perp))
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :content => "Lorem ipsum", :perp_id => @perp }
      end
      
      it "should create a statement" do
        lambda do
          post :create, :statement => @attr, :perp => @perp
        end.should change(Statement, :count).by(1)
      end
      
      it "should redirect to the perp page" do
        post :create, :statement => @attr, :perp => @perp
        response.should redirect_to(perp_path(@perp))
      end
      
      it "should have a flash message" do
        post :create, :statement => @attr, :perp => @perp
        flash[:success].should =~ /statement created/i
      end
    end
  end 
end
