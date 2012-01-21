require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.handle)
    end
    
    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.handle)
    end
  end

  describe "GET 'new'" do
    
    describe "as signed-out user" do
      it "should be successful" do
        get :new
        response.should be_success
      end
    
      it "should have the right title" do
        get :new
        response.should have_selector("title", :content => "Register")
      end
    
      it "should have a name field" do
        get :new
        response.should have_selector("input[name='user[handle]'][type='text']")
      end

      it "should have an email field" do
        get :new
        response.should have_selector("input[name='user[email]'][type='text']")
      end

      it "should have a password field" do
        get :new
        response.should have_selector("input[name='user[password]'][type='password']")
      end

      it "should have a confirm password field" do
        get :new
        response.should have_selector("input[name='user[password_confirmation]'][type='password']")
      end
    end
    
    describe "as signed-in user" do
      
      before(:each) do
        @user = Factory(:user, :email => "signed.in@user.com")
        test_sign_in(@user)
      end
      
      it "should redirect to root path" do
        get :new
        response.should redirect_to(root_path)
      end
    end
  end
  
  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { 
          :handle => "", 
          :email => "", 
          :password => "", 
          :password_confirmation => ""
          }
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Register")
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = {
          :handle => "New User", 
          :email => "new@email.com", 
          :password => "foobar", 
          :password_confirmation => "foobar"
        }
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        @user_session = UserSession.find
        @user_session.user.should_not == nil
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to hyp \& hype/i
      end
    end
    
    describe "as signed-in user" do
      
      before(:each) do
        test_sign_in(Factory(:user, :email => "signed.in@user.com"))
      end
      
      it "should redirect to root path" do
        post :create, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end
  
  describe "GET 'edit'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end
  end
  
  describe "PUT 'update'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    describe "failure" do
      
      before(:each) do
        @attr = {:email => "", :handle => "", :password => "", 
                 :password_confirmation => ""}
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { 
          :handle => "New Name", 
          :email => "user@example.org", 
          :password => "barbaz", 
          :password_confirmation => "barbaz"
        }
      end
      
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.handle.should  == @attr[:handle]
        @user.email.should == @attr[:email]
      end
      
      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end
      
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end
    end
  end
  
  describe "authentication of edit/update pages" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non-signed-in users" do
      
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for signed-in users" do
      
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end
      
      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end
    
    describe "as a non-admin user" do
      
      before(:each) do
        test_sign_in(@user)
      end
      
      it "should protect the page" do
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end
    
    describe "as an admin user" do
      
      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end
      
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
      
      it "should redirect to the root path" do
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
      
      it "should not allow self-destruction" do
        lambda do
          delete :destroy, :id => @admin
        end.should_not change(User, :count)
      end
    end
  end
end
