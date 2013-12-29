require 'spec_helper'

describe GamesHelper do

  before :each do
    @game = create(:game)
  end

  it 'returns X for a spot played by player 1' do
    @game.spots.first.update_attribute(:player, 1)
    expect(spot_status(1)).to eq('X')
  end

  it 'returns O for a spot played by player 2' do
    @game.spots.first.update_attribute(:player, 2)
    expect(spot_status(1)).to eq('O')
  end

  it 'returns a form for an unplayed spot' do
    expect(spot_status(9)).to have_selector('form')
  end

  it 'returns nothing for a game that is over' do
    @game.update_attribute(:status, 'over')
    expect(spot_status(4)).to be_nil
  end

end
