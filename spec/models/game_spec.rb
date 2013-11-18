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

  describe 'the computers second turn' do
    context 'in a middle game' do
      it 'plays X in the bottom-right corner (position 9)' do
        game = create(:middle_game)
        # game.spots.where(position: 1).first.player = 'X'
        # game.spots.where(position: 5).first.player = 'O'
        game.computers_second_turn
        expect(game.spots.where(position: 9).first.player).to eq('X')
      end
    end
  end

end
