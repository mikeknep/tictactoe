require 'spec_helper'

describe Spot do
  it 'has a valid factory' do
    expect(build(:spot)).to be_valid
  end

  it 'is invalid without a game_id' do
    expect(build(:spot, game_id: nil)).to_not be_valid
  end

  it 'is invalid without a position value' do
    expect(build(:spot, position: nil)).to_not be_valid
  end

  it 'has a unique position value within the context of a game' do
    create(:spot, game_id: 1, position: 5)
    bad_spot = build(:spot, game_id: 1, position: 5)
    expect(bad_spot).to_not be_valid
  end

  it 'has a position value greater than or equal to 1' do
    expect(build(:spot, position: 0)).to_not be_valid
  end

  it 'has a position value less than or equal to 9' do
    expect(build(:spot, position: 10)).to_not be_valid
  end

  it 'can be as yet unplayed' do
    expect(build(:spot, player: nil)).to be_valid
  end

  it 'can be played by the computer' do
    expect(build(:computer_spot)).to be_valid
  end

  it 'can be played by the human' do
    expect(build(:human_spot)).to be_valid
  end

  it 'can only be played by either X or O' do
    expect(build(:spot, player: 'V')).to_not be_valid
  end

end
