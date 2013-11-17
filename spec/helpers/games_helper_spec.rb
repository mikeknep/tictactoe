require 'spec_helper'

describe GamesHelper do

  before :each do
    @x = create(:computer_spot, game_id: 4, position: 3)
    @unplayed = create(:spot, game_id: 4, position: 5)
  end

  it 'returns the player value for a played spot' do
    expect(spot_status(@x.position, 4, 2)).to eq('X')
  end

  it 'returns a form for an unplayed spot'
    # FIXME: How to write rspec expect helper method to render a partial? Something like... expect(spot_status(@unplayed.position, 4)).to receive(:render).with('games/playable_spot_form') ?

  it 'returns a form that goes to the next human turn path' # FIXME: Need to figure out above spec to get to this one

end
