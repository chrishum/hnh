require 'spec_helper'

describe PartiesController do
  render_views

  describe "GET 'index'" do
    
    before(:each) do
      first  = Factory(:party, :name => "First")
      second = Factory(:party, :name => "Second")
      third  = Factory(:party, :name => "Third")
      @parties = [first, second, third]
      30.times do
        @parties << Factory(:party, :name => Factory.next(:name))
      end
    end
    
    it "should be successful" do
      get :index
      response.should be_success
    end
    
    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "Parties")
    end
    
    it "should have an element for each party" do
      get :index
      @parties[0..2].each do |party|
        response.should have_selector("li", :content => party.name)
      end
    end
    
    it "should paginate parties" do
      get :index
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a", :href => "/parties?page=2",
                                         :content => "2")
      response.should have_selector("a", :href => "/parties?page=2", 
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
      @party = Factory(:party)
    end
    
    it "should be successful" do
      get :show, :id => @party
      response.should be_success
    end
    
    it "should find the right perp" do
      get :show, :id => @party
      assigns(:party).should == @party
    end
    
    it "should have the right title" do
      get :show, :id => @party
      response.should have_selector("title", :content => @party.name)
    end
    
    it "should include the party's name" do
      get :show, :id => @party
      response.should have_selector("h1", :content => @party.name)
    end
    
    it "should show the party's perps" do
      perp1 = Factory(:perp, :party => @party, :first_name => "Joe")
      perp2 = Factory(:perp, :party => @party, :first_name => "Annie")
      get :show, :id => @party
      response.should have_selector("span.name", :content => perp1.first_name)
      response.should have_selector("span.name", :content => perp2.first_name)
    end
  end

  describe "GET 'new'" do

    before(:each) do
      @user = Factory(:user, :admin => true)
      test_sign_in(@user)
    end

    it "returns http success" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "New Party")
    end
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @user = Factory(:user, :admin => true)
      test_sign_in(@user)
    end
    
    describe "failure" do
      
      before(:each) do
        @attr = { 
          :name => "", 
          :three_letter => "", 
          :one_letter => ""
          }
      end
      
      it "should not create a party" do
        lambda do
          post :create, :party => @attr
        end.should_not change(Party, :count)
      end
      
      it "should have the right title" do
        post :create, :party => @attr
        response.should have_selector("title", :content => "New Party")
      end
      
      it "should render the 'new' page" do
        post :create, :party => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = {
          :name => "Charlie Party", 
          :three_letter => "CHP", 
          :one_letter => "C"
          }
      end
      
      it "should create a party" do
        lambda do
          post :create, :party => @attr
        end.should change(Party, :count).by(1)
      end
      
      it "should redirect to the party show page" do
        post :create, :party => @attr
        response.should redirect_to(party_path(assigns(:party)))
      end
    end
  end


  describe "GET 'edit'" do
    
    before(:each) do
      @user = Factory(:user, :admin => true)
      test_sign_in(@user)
      @party = Factory(:party)
    end
    
    it "should be successful" do
      get :edit, :id => @party
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @party
      response.should have_selector("title", :content => "Edit party")
    end
  end
  
  describe "PUT 'update'" do
    
    before(:each) do
      @user = Factory(:user, :admin => true)
      test_sign_in(@user)
      @party = Factory(:party)
    end
    
    describe "failure" do
      
      before(:each) do
        @attr = {
          :name => "", 
          :three_letter => "", 
          :one_letter => ""
        }
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @party, :party => @attr
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @party, :party => @attr
        response.should have_selector("title", :content => "Edit party")
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = {
          :name => "Charlie Party", 
          :three_letter => "CHP", 
          :one_letter => "C"
        }
      end
      
      it "should change the party's attributes" do
        put :update, :id => @party, :party => @attr
        @party.reload
        @party.name.should         == @attr[:name]
        @party.three_letter.should == @attr[:three_letter]
        @party.one_letter.should   == @attr[:one_letter]
      end
      
      it "should redirect to the party's show page" do
        put :update, :id => @party, :party => @attr
        response.should redirect_to(party_path(@party))
      end
      
      it "should have a flash message" do
        put :update, :id => @party, :party => @attr
        flash[:success].should =~ /updated/
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    
    before(:each) do
      @party = Factory(:party)
    end
    
    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @party
        response.should redirect_to(signin_path)
      end
    end
    
    describe "as a non-admin user" do
      
      before(:each) do
        non_admin = Factory(:user)
        test_sign_in(non_admin)
      end
      
      it "should protect the page" do
        delete :destroy, :id => @party
        response.should redirect_to(root_path)
      end
    end
    
    describe "as an admin user" do
      
      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end
      
      it "should destroy the party" do
        lambda do
          delete :destroy, :id => @party
        end.should change(Party, :count).by(-1)
      end
      
      it "should redirect to the party page" do
        delete :destroy, :id => @party
        response.should redirect_to(parties_path)
      end
    end
  end
  
  describe "authentication of pages" do
    
    before(:each) do
      @party = Factory(:party)
      @attr = {
        :name => "Charlie Party", 
        :three_letter => "CHP", 
        :one_letter => "C"
        }
    end
    
    describe "for non-signed-in users" do
      
      before(:each) do
        admin = Factory(:user, :admin => true)
      end

      it "should deny access to 'new'" do
        get :new
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to 'create'" do
        post :create, :party => @attr
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to 'edit'" do
        get :edit, :id => @party
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to 'update'" do
        put :update, :id => @party
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for non-admin users" do
      
      before(:each) do
        non_admin = Factory(:user)
        test_sign_in(non_admin)
      end

      it "should deny access to 'new'" do
        get :new
        response.should redirect_to(root_path)
      end
      
      it "should deny access to 'create'" do
        post :create, :party => @attr
        response.should redirect_to(root_path)
      end
      
      it "should deny access to 'edit'" do
        get :edit, :id => @party
        response.should redirect_to(root_path)
      end
      
      it "should deny access to 'update'" do
        put :update, :id => @party
        response.should redirect_to(root_path)
      end
    end
  end

end
