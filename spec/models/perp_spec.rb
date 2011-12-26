require 'spec_helper'

describe Perp do
  
  before(:each) do
    @attr = { 
      :first_name => "New", 
      :last_name => "Perp", 
      :party => "Independent"
      }
  end
  
  it "should create a new instance given valid attributes" do
    Perp.create!(@attr)
  end
  
  it "should require a first name" do
    no_name_perp = Perp.new(@attr.merge(:first_name => ""))
    no_name_perp.should_not be_valid
  end
  
  it "should require a last name" do
    no_name_perp = Perp.new(@attr.merge(:last_name => ""))
    no_name_perp.should_not be_valid
  end
  
  it "should reject first names that are too long" do
    long_name = "a" * 26
    long_name_user = User.new(@attr.merge(:first_name => long_name))
    long_name_user.should_not be_valid
  end

  it "should reject last names that are too long" do
    long_name = "a" * 26
    long_name_user = User.new(@attr.merge(:last_name => long_name))
    long_name_user.should_not be_valid
  end
  
end
# == Schema Information
#
# Table name: perps
#
#  id         :integer         not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  party      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

