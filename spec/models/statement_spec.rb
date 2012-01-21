require 'spec_helper'

describe Statement do
  
  before(:each) do
    @perp = Factory(:perp)
    @attr = { :content => "value for content" }
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
  
  describe "validations" do
    
    it "should require a perp id" do
      Statement.new(@attr).should_not be_valid
    end
    
    it "should require nonblank content" do
      @perp.statements.build(:content => "  ").should_not be_valid
    end
    
    it "should reject long content" do
      @perp.statements.build(:content => "a" * 141).should_not be_valid
    end
  end
end
# == Schema Information
#
# Table name: statements
#
#  id             :integer         not null, primary key
#  content        :string(255)
#  perp_id        :integer
#  date           :date
#  primary_source :string(255)
#  context        :text
#  description    :text
#  created_at     :datetime
#  updated_at     :datetime
#

