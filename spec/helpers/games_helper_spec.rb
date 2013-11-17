require 'spec_helper'

describe GamesHelper do

  before :each do
    @x = create(:computer_spot, game_id: 4, position: 3)
    @unplayed = create(:spot, game_id: 4, position: 5)
  end

  it 'returns the player value for a played spot' do
    expect(spot_status(@x.position, @x.game_id, 2)).to eq('X')
  end

  it 'returns a form for an unplayed spot' do
    expect(spot_status(@unplayed.position, @unplayed.game_id, 2)).to have_selector('form')
  end

  it 'returns a form that goes to the next human turn path' # Make sure the helper method is generating a form that goes to the correct PATCH route

end
