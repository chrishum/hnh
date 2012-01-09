require 'spec_helper'

describe PerpsController do
  render_views
  
  describe "GET 'index'" do
    
    before(:each) do
      first  = Factory(:perp, :first_name => "First")
      second = Factory(:perp, :first_name => "Second")
      third  = Factory(:perp, :first_name => "Third")
      @perps = [first, second, third]
      30.times do
        @perps << Factory(:perp, :last_name => Factory.next(:last_name))
      end
    end
    
    it "should be successful" do
      get :index
      response.should be_success
    end
    
    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "Perps")
    end
    
    it "should have an element for each perp" do
      get :index
      @perps[0..2].each do |perp|
        response.should have_selector("li", :content => perp.first_name)
      end
    end
    
    it "should paginate perps" do
      get :index
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a", :href => "/perps?page=2",
                                         :content => "2")
      response.should have_selector("a", :href => "/perps?page=2", 
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
    
    it "should show the perp's statements" do
      st1 = Factory(:statement, :perp => @perp, :content => "I never inhaled.")
      st2 = Factory(:statement, :perp => @perp, :content => "Pork and beans are Stalinist!")
      get :show, :id => @perp
      response.should have_selector("span.content", :content => st1.content)
      response.should have_selector("span.content", :content => st2.content)
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
    
    before(:each) do
      @party = Factory(:party)
    end
    
    describe "failure" do
      
      before(:each) do
        @attr = { 
          :first_name => "", 
          :last_name => ""
          }
      end
      
      it "should not create a perp" do
        lambda do
          post :create, :perp => @attr, :party => @party
        end.should_not change(Perp, :count)
      end
      
      it "should have the right title" do
        post :create, :perp => @attr, :party => @party
        response.should have_selector("title", :content => "New Perp")
      end
      
      it "should render the 'new' page" do
        post :create, :perp => @attr, :party => @party
        response.should render_template('new')
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = {
          :first_name => "New", 
          :last_name => "Perp"
          }
      end
      
      it "should create a perp" do
        lambda do
          post :create, :perp => @attr, :party => @party
        end.should change(Perp, :count).by(1)
      end
      
      it "should assign the correct party" do
        post :create, :perp => @attr, :party => @party
        Perp.last.party.should == @party
      end
            
      it "should redirect to the perp show page" do
        post :create, :perp => @attr, :party => @party
        response.should redirect_to(perp_path(assigns(:perp)))
      end
    end
  end
  
  describe "GET 'edit'" do
    
    before(:each) do
      test_sign_in(Factory(:user))
      @perp = Factory(:perp)
    end
    
    it "should be successful" do
      get :edit, :id => @perp
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @perp
      response.should have_selector("title", :content => "Edit perp")
    end
  end
  
  describe "PUT 'update'" do
    
    before(:each) do
      test_sign_in(Factory(:user))
      @perp = Factory(:perp)
    end
    
    describe "failure" do
      
      before(:each) do
        @party = ""
        @attr = {
          :first_name => "", 
          :last_name => ""
        }
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @perp, :perp => @attr, :party => @party
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @perp, :perp => @attr, :party => @party
        response.should have_selector("title", :content => "Edit perp")
      end
    end
    
    describe "success" do
      
      before(:each) do
        @party = Factory(:party)
        @attr = {
          :first_name => "New", 
          :last_name => "Perp"
        }
      end
      
      it "should change the perp's attributes" do
        put :update, :id => @perp, :perp => @attr, :party => @party
        @perp.reload
        @perp.first_name.should == @attr[:first_name]
        @perp.last_name.should  == @attr[:last_name]
        @perp.party.should      == @party
      end
      
      it "should redirect to the perp show page" do
        put :update, :id => @perp, :perp => @attr, :party => @party
        response.should redirect_to(perp_path(@perp))
      end
      
      it "should have a flash message" do
        put :update, :id => @perp, :perp => @attr, :party => @party
        flash[:success].should =~ /updated/
      end
    end
  end
  
  describe "authentication of edit/update pages" do
    
    before(:each) do
      @perp = Factory(:perp)
    end
    
    describe "for non-signed-in users" do
      
      it "should deny access to 'edit'" do
        get :edit, :id => @perp
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to 'update'" do
        put :update, :id => @perp, :perp => {}
        response.should redirect_to(signin_path)
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    
    before(:each) do
      @perp = Factory(:perp)
    end
    
    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @perp
        response.should redirect_to(signin_path)
      end
    end
    
    describe "as a non-admin user" do
      
      before(:each) do
        non_admin = Factory(:user)
        test_sign_in(non_admin)
      end
      
      it "should protect the page" do
        delete :destroy, :id => @perp
        response.should redirect_to(root_path)
      end
    end
    
    describe "as an admin user" do
      
      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end
      
      it "should destroy the perp" do
        lambda do
          delete :destroy, :id => @perp
        end.should change(Perp, :count).by(-1)
      end
      
      it "should redirect to the perps page" do
        delete :destroy, :id => @perp
        response.should redirect_to(perps_path)
      end
    end
  end
end
