require 'spec_helper'

describe PerpsController do
  render_views

  describe "GET 'show'" do
    
    before(:each) do
      @perp = Factory(:perp)
    end
    
    it "should be successful" do
      get :show, :id => @perp
      response.should be_success
    end
    
    it "should find the right perp" do
      get :show, :id => @perp
      assigns(:perp).should == @perp
    end
    
    it "should have the right title" do
      get :show, :id => @perp
      response.should have_selector("title", :content => @perp.first_name + " " + @perp.last_name)
    end
    
    it "should include the perp's name" do
      get :show, :id => @perp
      response.should have_selector("h1", :content => @perp.first_name)
    end
  end
  
  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "New Perp")
    end
  end
  
  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { 
          :first_name => "", 
          :last_name => "", 
          :party => ""
          }
      end
      
      it "should not create a perp" do
        lambda do
          post :create, :perp => @attr
        end.should_not change(Perp, :count)
      end
      
      it "should have the right title" do
        post :create, :perp => @attr
        response.should have_selector("title", :content => "New Perp")
      end
      
      it "should render the 'new' page" do
        post :create, :perp => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = {
          :first_name => "New", 
          :last_name => "Perp", 
          :party => "Independent"
          }
      end
      
      it "should create a perp" do
        lambda do
          post :create, :perp => @attr
        end.should change(Perp, :count).by(1)
      end
            
      it "should redirect to the perp show page" do
        post :create, :perp => @attr
        response.should redirect_to(perp_path(assigns(:perp)))
      end
    end
  end
end
