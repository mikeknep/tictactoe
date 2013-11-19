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

  describe 'the computers fourth turn' do
    context 'in a middle game' do
      before :each do
        @game = create(:middle_game)
        @game.computers_second_turn
        @game.human_turn(3)
        @game.computers_third_turn
      end

      it 'plays X in the middle-left spot (position 4) to win if it can' do
        @game.human_turn(9)
        @game.computers_fourth_turn
        expect(@game.spots.where(position: 4).first.player).to eq('X')
      end

      it "plays X in the middle-right corner (position 6) to block if it can't win" do
        @game.human_turn(4)
        @game.computers_fourth_turn
        expect(@game.spots.where(position: 6).first.player).to eq('X')
      end
    end
  end

  describe 'the computers fifth turn' do
    it 'plays the last available spot' do
      @game = create(:middle_game)
      @game.spots.where(position: 1).first.player = 'X'
      @game.human_turn(5)
      @game.computers_second_turn
      @game.human_turn(3)
      @game.computers_third_turn
      @game.human_turn(4)
      @game.computers_fourth_turn
      @game.human_turn(8)
      @game.computers_fifth_turn
      expect(@game.spots.where(player: nil).count).to eq(0)
    end
  end

  describe 'checking status' do
    it 'ends the game when the computer wins horizontally' do
      game = create(:game)
      game.spots.where('position = ? OR position = ? OR position = ?', 1, 2, 3).each do |spot|
        spot.player = 'X'
        spot.save
      end
      game.check_status
      expect(game.status).to eq('over')
    end

    it 'ends the game when the computer wins vertically' do
      game = create(:game)
      game.spots.where('position = ? OR position = ? OR position = ?', 1, 4, 7).each do |spot|
        spot.player = 'X'
        spot.save
      end
      game.check_status
      expect(game.status).to eq('over')
    end

    it 'ends the game when the computer wins diagonally' do
      game = create(:game)
      game.spots.where('position = ? OR position = ? OR position = ?', 1, 5, 9).each do |spot|
        spot.player = 'X'
        spot.save
      end
      game.check_status
      expect(game.status).to eq('over')
    end

    it 'ends the game when there are no positions left to play' do
      players = ['X', 'O']
      game = create(:game)
      game.spots.each do |spot|
        spot.player = players.sample
        spot.save
      end
      game.check_status
      expect(game.status).to eq('over')
    end
  end

end
