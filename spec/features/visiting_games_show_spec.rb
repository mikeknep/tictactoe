require 'spec_helper'

describe 'visit games#show' do
  subject { page }

  before :each do
    game = create(:game)
    visit(game_path(game))
  end

  it { should have_selector('h1') }
  it { should have_selector('table') }
  it { should have_selector('td', count: 9) }

end
