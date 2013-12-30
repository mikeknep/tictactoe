require 'spec_helper'

describe 'visit games#index' do
  subject { page }

  before :each do
    create_and_sign_in_user
    game = create(:game, user_id: @user.id)
    visit(games_path)
  end

  it { should have_selector('h2', text: 'Games') }
  it { should have_selector('li') }
  it { should have_selector('a') }
  it { should have_button('Play as X') }
  it { should have_button('Play as O') }

end
