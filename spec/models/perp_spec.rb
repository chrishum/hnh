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
  
  describe "attributes" do

    before(:each) do
      @perp = @party.perps.create!(@attr)
    end
    
    it "should have the correct full_name" do
      @perp.should respond_to(:full_name)
      @perp.full_name.should == "#{@perp.first_name} #{@perp.last_name}"
    end
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
      @st1 = Factory(:statement, :perp => @perp, :date => 1.week.ago)
      @st2 = Factory(:statement, :perp => @perp, :date => 1.day.ago)
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
      @party = Factory(:party)
      @perp = @party.perps.create(@attr)
    end
    
    it "should have a party attribute" do
      @perp.should respond_to(:party)
    end
    
    it "should have the correct party_name attribute" do
      @perp.should respond_to(:party_name)
      @perp.party_name.should == @party.name
    end
    
    it "should have the correct party_three_letter attribute" do
      @perp.should respond_to(:party_three_letter)
      @perp.party_three_letter.should == @party.three_letter
    end
    
    it "should have the correct party_one_letter attribute" do
      @perp.should respond_to(:party_one_letter)
      @perp.party_one_letter.should == @party.one_letter
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

