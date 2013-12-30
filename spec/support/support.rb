require 'spec_helper'

def create_and_sign_in_user
  @user = create(:user)
  visit(new_session_path)
  fill_in "Username", with: "batman"
  fill_in "Password", with: "gotham"
  click_button "Sign in"
end

