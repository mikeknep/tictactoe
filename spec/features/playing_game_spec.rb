require 'spec_helper'

feature 'Playing a game' do

  before :each do
    create_and_sign_in_user
    click_button('Play as O')
  end

  scenario 'creating a game' do
    expect(page).to have_selector('div.square', count: 9)
  end

  scenario 'deleting a game' do
    click_link('Delete')
    expect(page).to have_button('Play as X')
  end

  scenario 'taking a turn' do
    first('.btn-default').click
    expect(page).to have_selector('form', count: 6)
  end

  scenario 'losing' do
    first('.btn-default').click  # => O plays spot 2, which prompts X to play spot 5
    first('.btn-default').click  # => O plays spot 3, which prompts X to play spot 9 to win
    expect(page).to have_selector('form', count: 2) # Two "play again?" submit buttons
  end

end
