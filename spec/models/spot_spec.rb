require 'spec_helper'

describe Spot do
  it 'belongs to a game' do
    expect(build(:spot)).to be_valid
  end

  it 'is invalid without a game_id' do
    expect(build(:spot, game_id: nil)).to_not be_valid
  end

  it 'is invalid without a position value' do
    expect(build(:spot, position: nil)).to_not be_valid
  end

  it 'has a unique position value within the context of a game' do
    game = create(:game)
    create(:spot, game: game, position: 1)
    bad_spot = build(:spot, game: game, position: 1)
    expect(bad_spot).to_not be_valid
  end

  it 'has a position value greater than or equal to 1' do
    expect(build(:spot, position: 0)).to_not be_valid
  end

  it 'has a position value less than or equal to 9' do
    expect(build(:spot, position: 10)).to_not be_valid
  end

end
