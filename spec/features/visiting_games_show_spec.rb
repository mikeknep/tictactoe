require 'spec_helper'

describe 'visit games#show' do
  subject { page }

  before :each do
    create_and_sign_in_user
    click_button('New Game')
  end

  it { should have_selector('h1') }
  it { should have_selector('div.gameboard') }
  it { should have_selector('div.square', count: 9) }
  it { should have_selector('a', text: 'Back') }
  it { should have_selector('a', text: 'Delete') }

end
