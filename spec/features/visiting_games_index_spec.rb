require 'spec_helper'

describe 'visit games#index' do
  subject { page }

  before :each do
    game = create(:game)
    visit(games_path)
  end

  it { should have_selector('h1', text: 'Games') }
  it { should have_selector('li') }
  it { should have_selector('a') }
  it { should have_button('New Game') }

end
