require 'spec_helper'

describe GamesHelper do

  before :each do
    @game = create(:game)
    @x = @game.spots.first
    @x.player = 'X'
    @unplayed = @game.spots.last
  end

  it 'returns the player value for a played spot' do
    expect(spot_status(@x.position)).to eq('X')
  end

  it 'returns a form for an unplayed spot' do
    expect(spot_status(@unplayed.position)).to have_selector('form')
  end

  it 'returns nothing for a game that is over' do
    @game.status = 'over'
    @game.save
    expect(spot_status(4)).to be_nil
  end

end
