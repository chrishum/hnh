require 'spec_helper'

describe Perp do
  
  before(:each) do
    @party = Factory(:party)
    @attr = { 
      :first_name => "New", 
      :last_name => "Perp"
      }
  end
  
  it "should create a new instance given valid attributes" do
    @party.perps.create!(@attr)
  end
  
  describe "validations" do

    it "should require a first name" do
      no_name_perp = @party.perps.new(@attr.merge(:first_name => ""))
      no_name_perp.should_not be_valid
    end
  
    it "should require a last name" do
      no_name_perp = @party.perps.new(@attr.merge(:last_name => ""))
      no_name_perp.should_not be_valid
    end
  
    it "should reject first names that are too long" do
      long_name = "a" * 26
      long_name_perp = @party.perps.new(@attr.merge(:first_name => long_name))
      long_name_perp.should_not be_valid
    end

    it "should reject last names that are too long" do
      long_name = "a" * 26
      long_name_perp = @party.perps.new(@attr.merge(:last_name => long_name))
      long_name_perp.should_not be_valid
    end
    
    it "should require a party id" do
      Perp.new(@attr).should_not be_valid
    end
  end
  
  describe "statement associations" do
    
    before(:each) do
      @perp = @party.perps.create(@attr)
      @st1 = Factory(:statement, :perp => @perp, :created_at => 1.day.ago)
      @st2 = Factory(:statement, :perp => @perp, :created_at => 1.hour.ago)
    end
    
    it "should have a statements attribute" do
      @perp.should respond_to(:statements)
    end
    
    it "should have the right statements in the right order" do
      @perp.statements.should == [@st2, @st1]
    end
    
    it "should destroy associated statements" do
      @perp.destroy
      [@st1, @st2].each do |statement|
        Statement.find_by_id(statement.id).should be_nil
      end
    end
  end
  
  describe "party association" do
    
    before(:each) do
      @perp = Perp.create(@attr)
    end
    
    it "should have a party attribute" do
      @perp.should respond_to(:party)
    end
  end
end
# == Schema Information
#
# Table name: perps
#
#  id         :integer         not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  party_id   :integer
#

