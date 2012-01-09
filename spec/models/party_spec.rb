require 'spec_helper'

describe Party do
  
  before(:each) do
    @attr = { :name => "New Party", 
              :three_letter => "NPA", 
              :one_letter => "N" }
  end
  
  it "should create a new instance given valid attributes" do
    Party.create!(@attr)
  end
  
  describe "validations" do
    
    describe "name" do
      
      it "should require a name" do
        no_name_party = Party.new(@attr.merge(:name => ""))
        no_name_party.should_not be_valid
      end
    
      it "should reject long names" do
        long_name_party = Party.new(@attr.merge(:name => "a" * 31))
        long_name_party.should_not be_valid
      end
      
      it "should reject dublicate names" do
        Party.create!(@attr)
        duplicate_party = Party.new(@attr)
        duplicate_party.should_not be_valid
      end
    end
    
    describe "three-letter abbreviation" do
      
      it "should require a three-letter abbreviation" do
        no_abbr_party = Party.new(@attr.merge(:three_letter => ""))
        no_abbr_party.should_not be_valid
      end
      
      it "should reject abbreviations over 3 letters" do
        long_abbr_party = Party.new(@attr.merge(:three_letter => "xxxx"))
        long_abbr_party.should_not be_valid
      end
    end
    
    describe "one-letter abbreviation" do
      
      it "should require a one-letter abbreviation" do
        no_abbr_party = Party.new(@attr.merge(:one_letter => ""))
        no_abbr_party.should_not be_valid
      end
      
      it "should reject abbreviations over 1 letters" do
        long_abbr_party = Party.new(@attr.merge(:one_letter => "xx"))
        long_abbr_party.should_not be_valid
      end
    end
  end
end
# == Schema Information
#
# Table name: parties
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  three_letter :string(255)
#  one_letter   :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

