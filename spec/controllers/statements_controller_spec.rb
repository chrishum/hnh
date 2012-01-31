require 'spec_helper'

describe StatementsController do
  render_views
  
  describe "access control" do
    
    before(:each) do
      @perp = Factory(:perp)
    end
    
    it "should deny access to 'create'" do
      post :create, :perp_id => @perp
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'destroy'" do
      delete :destroy, :perp_id => @perp, :id => 1
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
        response.should have_selector("h1", :content => statement.content)
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

  describe "GET 'show'" do
    
    before(:each) do
      @statement = Factory(:statement)
      @perp = @statement.perp
    end
    
    it "should be successful" do
      get :show, :perp_id => @perp, :id => @statement
      response.should be_success
    end
    
    it "should find the right statement" do
      get :show, :perp_id => @perp, :id => @statement
      assigns(:statement).should == @statement
    end
    
    it "should have the right title" do
      get :show, :perp_id => @perp, :id => @statement
      response.should have_selector("title", :content => @statement.perp_name)
    end
    
    it "should include the statement's content" do
      get :show, :perp_id => @perp, :id => @statement
      response.should have_selector("h1", :content => "\"" + @statement.content + "\"")
    end
    
    it "should include a link with the perp's name" do
      get :show, :perp_id => @perp, :id => @statement
      response.should have_selector("a", :content => @statement.perp_name)
    end
  end

  describe "POST 'create'" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
      @perp = Factory(:perp)
    end
    
    describe "failure" do
      
      before(:each) do
        @attr = { :content          => "", 
                  :date             => "", 
                  :primary_source   => "", 
                  :context          => "", 
                  :why_hypocritical => "", 
                  :why_hyperbolical => "" 
                  }
      end
      
      it "should not create a statement" do
        lambda do
          post :create, :perp_id => @perp, :statement => @attr
        end.should_not change(Statement, :count)
      end
      
      it "should render the perp page" do
        post :create, :perp_id => @perp, :statement => @attr
        response.should redirect_to(perp_path(@perp))
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :content          => "Bluster and hot air.", 
                  :date             => "2011-12-31", 
                  :primary_source   => "http://www.source.com", 
                  :context          => "Overheard in a bathroom stall at the Minneapolis airport.", 
                  :why_hypocritical => "Just because, OK?", 
                  :why_hyperbolical => "Why not?" 
                  }
      end
      
      it "should create a statement" do
        lambda do
          post :create, :perp_id => @perp, :statement => @attr
        end.should change(Statement, :count).by(1)
      end
      
      it "should redirect to the perp page" do
        post :create, :perp_id => @perp, :statement => @attr
        response.should redirect_to(perp_path(@perp))
      end
      
      it "should have a flash message" do
        post :create, :perp_id => @perp, :statement => @attr
        flash[:success].should =~ /statement created/i
      end
    end
  end 
end
