require 'spec_helper'

describe "FriendlyForwardings" do
  
  it "should forward to user edit page after signin" do
    user = Factory(:user)
    visit edit_user_path(user)
    # Test automatically follows the redirect to the signin path
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
    # Test follows the redirect again, this time to users/edit
    response.should render_template('users/edit')
  end

  it "should forward to perp edit page after signin" do
    user = Factory(:user)
    visit edit_perp_path(Factory(:perp))
    # Test automatically follows the redirect to the signin path
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
    # Test follows the redirect again, this time to users/edit
    response.should render_template('perps/edit')
  end

end
