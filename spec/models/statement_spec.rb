require 'spec_helper'

describe Statement do
  
  before(:each) do
    @perp = Factory(:perp)
    @attr = { :content          => "Bluster and hot air.", 
              :date             => "2011-12-31", 
              :primary_source   => "http://www.source.com", 
              :context          => "Overheard in a bathroom stall at the Minneapolis airport.", 
              :why_hypocritical => "Just because, OK?", 
              :why_hyperbolical => "Why not?" 
              }
  end
  
  it "should create a new instance given valid attributes" do
    @perp.statements.create!(@attr)
  end
  
  describe "perp associations" do
    
    before(:each) do
      @statement = @perp.statements.create(@attr)
    end
    
    it "should have a perp attribute" do
      @statement.should respond_to(:perp)
    end
    
    it "should have the right associated perp" do
      @statement.perp_id.should == @perp.id
      @statement.perp.should == @perp
    end
    
    it "should have a party attribute" do
      @statement.should respond_to(:party)
    end
    
    it "should have the correct party_name attribute" do
      @statement.should respond_to(:party_name)
      @statement.party_name.should == @perp.party_name
    end
    
    it "should have the correct party_three_letter attribute" do
      @statement.should respond_to(:party_three_letter)
      @statement.party_three_letter.should == @perp.party_three_letter
    end
    
    it "should have the correct party_one_letter attribute" do
      @statement.should respond_to(:party_one_letter)
      @statement.party_one_letter.should == @perp.party_one_letter
    end
  end

  describe "ratings association" do
    
    before(:each) do
      @statement = @perp.statements.create(@attr)
    end

    it "should respond to hypocrisy_ratings" do
      @statement.should respond_to(:hypocrisy_ratings)
    end
    
    it "should have the correct hypocrisy_ratings_count" do
      @hypocrisy_ratings = []
      2.times do
        @hypocrisy_ratings << Factory(:hypocrisy_rating, :statement => @statement)
      end
      @statement.reload.hypocrisy_ratings_count.should == @hypocrisy_ratings.count
    end
    
    it "should respond to hyperbole_ratings" do
      @statement.should respond_to(:hyperbole_ratings)
    end
    
    it "should have the correct hyperbole_ratings_count" do
      @hyperbole_ratings = []
      3.times do
        @hyperbole_ratings << Factory(:hyperbole_rating, :statement => @statement)
      end
      @statement.reload.hyperbole_ratings_count.should == @hyperbole_ratings.count
    end
  end
  
  describe "ratings and scores" do
    
    before(:each) do
      @statement = @perp.statements.create(@attr)
    end
    
    describe "below the scoring threshold" do
      
      it "should not have a hypocrisy score" do
        4.times do
          Factory(:hypocrisy_rating, :statement => @statement)
        end
        @statement.hypocrisy_score.should be_nil
      end

      it "should not have a hyperbole score" do
        4.times do
          Factory(:hyperbole_rating, :statement => @statement)
        end
        @statement.hyperbole_score.should be_nil
      end
      
      it "should not have a total score" do
        4.times do
          Factory(:hypocrisy_rating, :statement => @statement)
          Factory(:hyperbole_rating, :statement => @statement)
        end
        @statement.score.should be_nil
      end
    end
    
    describe "above the scoring threshold" do
      
      it "should have the correct hypocrisy score" do
        @hypocrisy_ratings = []
        5.times do
          @hypocrisy_ratings << Factory(:hypocrisy_rating, :statement => @statement, 
                                                           :rating => (rand * 100).to_i)
        end
        @statement.hypocrisy_score.should == (@hypocrisy_ratings.collect(&:rating).sum.to_f / @hypocrisy_ratings.size).to_i
      end

      it "should have the correct hyperbole score" do
        @hyperbole_ratings = []
        5.times do
          @hyperbole_ratings << Factory(:hyperbole_rating, :statement => @statement, 
                                                           :rating => (rand * 100).to_i)
        end
        @statement.hyperbole_score.should == (@hyperbole_ratings.collect(&:rating).sum.to_f / @hyperbole_ratings.size).to_i
      end
      
      it "should have the correct overall score" do
        @hypocrisy_ratings = []
        @hyperbole_ratings = []
        5.times do
          @hypocrisy_ratings << Factory(:hypocrisy_rating, :statement => @statement, 
                                                           :rating => (rand * 100).to_i)
          @hyperbole_ratings << Factory(:hyperbole_rating, :statement => @statement, 
                                                           :rating => (rand * 100).to_i)
        end
        @statement.score.should == (((@hypocrisy_ratings.collect(&:rating).sum.to_f / @hypocrisy_ratings.size) + 
                                     (@hyperbole_ratings.collect(&:rating).sum.to_f / @hyperbole_ratings.size)) / 2).to_i
      end
    end
  end
  
  describe "validations" do
        
    it "should require a perp id" do
      Statement.new(@attr).should_not be_valid
    end
    
    it "should require nonblank content" do
      @perp.statements.build(@attr.merge(:content => "  ")).should_not be_valid
    end
    
    it "should reject long content" do
      @perp.statements.build(@attr.merge(:content => "a" * 141)).should_not be_valid
    end
    
    it "should require nonblank context" do
      @perp.statements.build(@attr.merge(:context => "  ")).should_not be_valid
    end
    
    it "should reject long context" do
      @perp.statements.build(@attr.merge(:context => "a" * 251)).should_not be_valid
    end
    
  end
end
# == Schema Information
#
# Table name: statements
#
#  id                      :integer         not null, primary key
#  content                 :string(255)
#  perp_id                 :integer
#  date                    :date
#  primary_source          :string(255)
#  context                 :text
#  why_hypocritical        :text
#  created_at              :datetime
#  updated_at              :datetime
#  why_hyperbolical        :text
#  hypocricy_score         :integer
#  hyperbole_score         :integer
#  score                   :integer
#  hypocrisy_ratings_count :integer         default(0)
#  hyperbole_ratings_count :integer         default(0)
#

