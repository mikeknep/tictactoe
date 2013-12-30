require 'spec_helper'

feature 'Visitor signs up' do
  subject { page }

  before :each do
    create(:user, username: 'batman')
  end

  scenario 'with valid email and password' do
    visit(new_user_path)
    fill_in 'Username', with: 'heisenberg'
    fill_in 'Password', with: 'vamanospest'
    fill_in 'Password confirmation', with: 'vamanospest'
    click_button 'Submit'
    expect(page).to have_selector('a', text: 'Sign out')
  end

  scenario 'with already taken email' do
    visit(new_user_path)
    fill_in 'Username', with: 'batman'
    fill_in 'Password', with: 'gotham'
    fill_in 'Password confirmation', with: 'gotham'
    click_button 'Submit'
    expect(page).to have_button('Submit')
  end

  scenario 'with blank password' do
    visit(new_user_path)
    fill_in 'Username', with: 'heisenberg'
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    click_button 'Submit'
    expect(page).to have_button('Submit')
  end

end
