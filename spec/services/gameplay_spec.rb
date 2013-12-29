require 'spec_helper'

describe Gameplay do

  context 'initializing' do
    it 'identifies the correct game' do
      pending
    end

    it 'identifies the position the human selected to play' do
      pending
    end

    it 'determines which player (human or computer) is first and which is second' do
      pending
    end
  end


  context 'playing turns' do
    it "plays the human's turn" do
      pending
    end

    it "plays the computer's turn" do
      pending
    end
  end


  context "determining the computer's next move" do
    it "defaults to playing the first available spot on the board if there is no better choice" do
      pending
    end

    context "on the computer's first turn following a human turn" do
      it "plays the middle spot if it is available" do
        pending
      end

      it "plays the top corner spot if it is available and the middle is taken" do
        pending
      end

      it "plays spot 2 if the middle and top corner are both taken" do
        pending
      end
    end

    it "plays a spot that blocks the opponent from winning if it can't win and the opponent is one spot away from winning" do
      pending
    end

    it 'plays a spot that leads to victory if one is available' do
      pending
    end
  end


  context 'at the end of the game' do
    it "doesn't play a move for the computer if there are no spots left" do
      pending
    end

    it 'changes the game status to "over" if the computer wins' do
      pending
    end

    it 'changes the game status to "over" if there are no spots left to play' do
      pending
    end
  end

end
