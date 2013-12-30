require 'spec_helper'

describe Gameplay do

  let(:game) { create(:game) }
  let(:gameplay) { Gameplay.new(id: game.id, position: 9) }

  context 'initializing' do
    it 'assigns the human player number 1 when the human plays first' do
      gameplay.play_turns
      expect(game.gamespot(9).player).to eq(1)
    end

    it 'assigns the human player number 2 when the human plays second' do
      game.gamespot(1).update_attribute(:player, 1)
      gameplay.play_turns
      expect(game.gamespot(9).player).to eq(2)
    end
  end


  context 'playing turns' do
    it "plays player 1's turn" do
      expect {
        gameplay.play_turns
      }.to change(Spot.where(player: 1), :count).by(1)
    end

    it "plays player 2's turn" do
      expect {
        gameplay.play_turns
      }.to change(Spot.where(player: 2), :count).by(1)
    end

    it "doesn't play a turn for player 2 when there are no open spots left" do
      8.times { |i| game.gamespot(i+1).update_attribute(:player, i%2+1) }
      expect {
        gameplay.play_turns
      }.to_not change(Spot.where(player: 2), :count)
    end
  end


  context "determining the computer's next move" do
    it "defaults to playing the first available spot on the board if there is no better choice" do
      game.gamespot(1).update_attribute(:player, 1)
      game.gamespot(2).update_attribute(:player, 2)
      game.gamespot(5).update_attribute(:player, 1)
      gameplay.play_turns
      expect(game.gamespot(3).player).to eq(1)
    end

    context "on the computer's first turn following a human turn" do
      it "plays the middle spot if it is available" do
        game.gamespot(1).update_attribute(:player, 1)
        gameplay.play_turns
        expect(game.gamespot(5).player).to eq(1)
      end

      it "plays the top corner spot if it is available and the middle is taken" do
        Gameplay.new(id: game.id, position: 5).play_turns
        expect(game.gamespot(1).player).to eq(2)
      end

      it "plays spot 2 if the middle and top corner are both taken" do
        game.gamespot(1).update_attribute(:player, 1)
        Gameplay.new(id: game.id, position: 5).play_turns
        expect(game.gamespot(2).player).to eq(1)
      end
    end

    it "plays a spot that blocks the opponent from winning if it can't win and the opponent is one spot away from winning" do
      game.gamespot(6).update_attribute(:player, 1)
      game.gamespot(7).update_attribute(:player, 2)
      gameplay.play_turns
      expect(game.gamespot(3).player).to eq(2)
    end

    it 'plays a spot that leads to victory if one is available' do
      [2,3].each { |i| game.gamespot(i).update_attribute(:player, 1) }
      [1,4].each { |i| game.gamespot(i).update_attribute(:player, 2) }
      gameplay.play_turns
      expect(game.gamespot(7).player).to eq(2)
    end
  end


  context 'updating the game status' do
    it 'changes the game status to "loss" if the computer wins' do
      [2,5,8].each { |i| game.gamespot(i).update_attribute(:player, 1) }
      gameplay.check_status
      game.reload
      expect(game.status).to eq('loss')
    end

    it 'changes the game status to "draw" if there are no spots left to play' do
      game.spots.where(position: [1,3,4,8,9]).each { |s| s.update_attribute(:player, 1) }
      game.spots.where(position: [2,5,6,7]).each { |s| s.update_attribute(:player, 2) }
      gameplay.check_status
      game.reload
      expect(game.status).to eq('draw')
    end
  end

end
