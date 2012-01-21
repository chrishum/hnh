require 'spec_helper'

describe Office do
  before(:each) do
    @perp = Factory(:perp)
    @attr = { :title => "New Office", 
              :state => "CA", 
              :start_date => "2009-01-01", 
              :end_date => "2011-12-31" }
    @party_id = @perp.party_id
  end
  
  it "should create a new instance given valid attributes" do
    @perp.offices.create!(@attr)
  end
  
  describe "validations" do
    
    describe "title" do
      
      it "should require a title" do
        no_title = @perp.offices.new(@attr.merge(:title => ""))
        no_title.party_id = @party_id
        no_title.should_not be_valid
      end
    
      it "should reject long titles" do
        long_title = @perp.offices.new(@attr.merge(:title => "a" * 61))
        long_title.party_id = @party_id
        long_title.should_not be_valid
      end
    end
    
    describe "state" do
      
      it "should require a state" do
        no_state = @perp.offices.new(@attr.merge(:state => ""))
        no_state.party_id = @party_id
        no_state.should_not be_valid
      end
      
      it "should reject long states" do
        long_state = @perp.offices.new(@attr.merge(:state => "aaa"))
        long_state.party_id = @party_id
        long_state.should_not be_valid
      end
    end
    
    describe "start date" do
      
      it "should require a start date" do
        no_start_date = @perp.offices.new(@attr.merge(:start_date => ""))
        no_start_date.party_id = @party_id
        no_start_date.should_not be_valid
      end
      
      it "should fall before or equal to end date" do
        late_start_date = @perp.offices.new(@attr.merge(:start_date => "2010-01-01", :end_date => "2009-01-01"))
        late_start_date.party_id = @party_id
        late_start_date.should_not be_valid
      end
    end
  end
end
# == Schema Information
#
# Table name: offices
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  state      :string(255)
#  party_id   :integer
#  start_date :date
#  end_date   :date
#  perp_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

