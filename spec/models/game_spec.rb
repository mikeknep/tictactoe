require 'spec_helper'

describe Game do

  it 'has a valid factory' do
    expect(build(:game)).to be_valid
  end

  it 'is invalid without a status' do
    expect(build(:game, status: nil)).to_not be_valid
  end

  it 'has nine spots' do
    game = create(:game)
    expect(game.spots.length).to eq(9)
  end

  it 'returns a specific spot on the gameboard' do
    game = create(:game)
    expect(game.gamespot(7)).to eq(game.spots.where(position: 7).first)
  end

end
