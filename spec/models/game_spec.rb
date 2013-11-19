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

  it 'allows the human to play' do
    game = create(:game)
    game.human_turn(4)
    expect(game.spots.where(position: 4).first.player).to eq('O')
  end

  describe 'the computers second turn' do
    context 'in a middle game' do
      it 'plays X in the top-middle spot (position 2)' do
        game = create(:middle_game)
        game.computers_second_turn
        expect(game.spots.where(position: 2).first.player).to eq('X')
      end
    end
  end

  describe 'the computers third turn' do
    context 'in a middle game' do
      before :each do
        @game = create(:middle_game)
        @game.computers_second_turn
      end

      it 'plays X in the top-right spot (position 3) to win if it can' do
        @game.human_turn(8)
        @game.computers_third_turn
        expect(@game.spots.where(position: 3).first.player).to eq('X')
      end

      it "plays X in the bottom-left corner (position 7) if it can't win" do
        @game.human_turn(3)
        @game.computers_third_turn
        expect(@game.spots.where(position: 7).first.player).to eq('X')
      end
    end
  end

  describe 'checking for victory' do
    it 'ends the game when the computer wins horizontally' do
      game = create(:game)
      game.spots.where('position = ? OR position = ? OR position = ?', 1, 2, 3).each do |spot|
        spot.player = 'X'
        spot.save
      end
      game.check_for_victory
      expect(game.status).to eq('over')
    end

    it 'ends the game when the computer wins vertically' do
      game = create(:game)
      game.spots.where('position = ? OR position = ? OR position = ?', 1, 4, 7).each do |spot|
        spot.player = 'X'
        spot.save
      end
      game.check_for_victory
      expect(game.status).to eq('over')
    end

    it 'ends the game when the computer wins diagonally' do
      game = create(:game)
      game.spots.where('position = ? OR position = ? OR position = ?', 1, 5, 9).each do |spot|
        spot.player = 'X'
        spot.save
      end
      game.check_for_victory
      expect(game.status).to eq('over')
    end
  end

end
