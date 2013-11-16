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

  it 'is identified as a corner game if the opponent plays a corner spot with their first move'

  it 'is identified as a peninsula game if the opponent plays a peninsula spot with their first move'

  it 'is identified as a middle game if the opponent plays the middle spot with their first move'

end
