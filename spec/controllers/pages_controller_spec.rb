require 'spec_helper'

describe PagesController do
  render_views
  
  before(:each) do
    @base_title = "H&H"
  end

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'home'
      response.should have_selector("title", 
                                    :content => @base_title + " | Home")
    end
    
    describe "latest statements section" do
      
      before(:each) do
        @statements = []
        @statements << Factory(:statement)
        @statements << Factory(:statement)
        @statements << Factory(:statement)
      end
        
      it "should have a list of the latest statements" do
        get 'home'
        response.should have_selector("td", :content => @statements[0].content)
        response.should have_selector("td", :content => @statements[1].content)
        response.should have_selector("td", :content => @statements[2].content)
      end
    end
  end

  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title", 
                                    :content => @base_title + " | Contact")
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title", 
                                    :content => @base_title + " | About")
    end
  end
  
end
