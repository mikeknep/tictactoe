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

  describe 'the computers second move' do
    before :each do
      @game = create(:game)
      # @game.spots.where(position: 1).first.player = 'X'
    end

    context 'in a corner game' do

    end

    context 'in a peninsula game' do

    end

    context 'in a middle game' do
      # @game.spots.where(position: 5).first.player = 'O'
      # @game.computers_second_move
      # expect(@game.spots.where(position: 5).first.player).to eq('X')
    end
  end

end
