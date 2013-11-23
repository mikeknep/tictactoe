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

  it 'allows the human to play' do
    game = create(:game)
    game.human_turn(4)
    expect(game.gamespot(4).player).to eq('O')
  end

  describe 'saving the gametype' do
    it 'saves as a corner-type game when the human plays 3, 7, or 9 on the first turn' do
      game = build(:game, human_turns: 1)
      game.set_gametype([3,7,9].sample)
      expect(game.gametype).to eq('corner')
    end

    it 'saves as a peninsula-type game when the human plays 2, 4, 6, or 8 on the first turn' do
      game = build(:game, human_turns: 1)
      game.set_gametype([2,4,6,8].sample)
      expect(game.gametype).to eq('peninsula')
    end

    it 'saves as a corner-type game when the human plays 5 on the first turn' do
      game = build(:game, human_turns: 1)
      game.set_gametype(5)
      expect(game.gametype).to eq('middle')
    end
  end


  describe 'the computer playing a middle game' do
    before :each do
      @game = create(:middle_game)
    end

    context "on its second turn" do
      it 'plays X in position 2' do
        @game.computers_second_turn
        expect(@game.gamespot(2).player).to eq('X')
      end
    end

    context "on it's third turn" do
      before :each do
        @game.computers_second_turn
      end

      it 'plays X in position 3 to win if it can' do
        @game.human_turn(8)
        @game.computers_third_turn
        expect(@game.gamespot(3).player).to eq('X')
      end

      it "plays X in position 7 if it can't win" do
        @game.human_turn(3)
        @game.computers_third_turn
        expect(@game.gamespot(7).player).to eq('X')
      end
    end

    context "on it's fourth turn" do
      before :each do
        @game.computers_second_turn
        @game.human_turn(3)
        @game.computers_third_turn
      end

      it 'plays X in position 4 to win if it can' do
        @game.human_turn(9)
        @game.computers_fourth_turn
        expect(@game.gamespot(4).player).to eq('X')
      end

      it "plays X in position 6 to block if it can't win" do
        @game.human_turn(4)
        @game.computers_fourth_turn
        expect(@game.gamespot(6).player).to eq('X')
      end
    end

    context "on it's fifth turn" do
      before :each do
        @game.computers_second_turn
        @game.human_turn(3)
        @game.computers_third_turn
        @game.human_turn(4)
        @game.computers_fourth_turn
      end

      it 'plays the last remaining position' do
        @game.human_turn(8)
        @game.computers_fifth_turn
        expect(@game.spots.where(player: nil).count).to eq(0)
      end
    end
  end


  describe 'the computer playing a corner game' do
    context "on its second turn" do
      before :each do
        @corner_game = create(:corner_game)
      end

      it 'plays X in position 3 if it is available' do
        @corner_game.human_turn(9)
        @corner_game.computers_second_turn
        expect(@corner_game.gamespot(3).player).to eq('X')
      end

      it 'plays X in position 7 if spot 3 is taken' do
        @corner_game.human_turn(3)
        @corner_game.computers_second_turn
        expect(@corner_game.gamespot(7).player).to eq('X')
      end
    end

    context "on it's third turn" do
      context "when x has position 3" do
        before :each do
          @x_has_3 = create(:x_has_3)
          @x_has_3.computers_second_turn
        end

        it 'plays X in position 2 to win if it is available' do
          @x_has_3.human_turn(8)
          @x_has_3.computers_third_turn
          expect(@x_has_3.gamespot(2).player).to eq('X')
        end

        it "plays X in the last available corner if it can't win" do
          @x_has_3.human_turn(2)
          @x_has_3.computers_third_turn
          expect(@x_has_3.gamespot(7).player).to eq('X')
        end
      end

      context "when x has position 7" do
        before :each do
          @x_has_7 = create(:x_has_7)
          @x_has_7.computers_second_turn
        end

        it 'plays X in position 4 to win if it is available' do
          @x_has_7.human_turn(6)
          @x_has_7.computers_third_turn
          expect(@x_has_7.gamespot(4).player).to eq('X')
        end

        it "plays X in the last available corner if it can't win" do
          @x_has_7.human_turn(4)
          @x_has_7.computers_third_turn
          expect(@x_has_7.gamespot(9).player).to eq('X')
        end
      end
    end

    context "on it's fourth turn" do
      context "when x has positions 3 and 7" do
        before :each do
          @three_seven = create(:x_has_3)
          @three_seven.computers_second_turn
          @three_seven.human_turn(2)
          @three_seven.computers_third_turn
        end

        it 'plays position 5 to win diagonally if it can' do
          @three_seven.human_turn(6)
          @three_seven.computers_fourth_turn
          expect(@three_seven.gamespot(5).player).to eq('X')
        end

        it "plays position 4 to win vertically if it can't win diagonally" do
          @three_seven.human_turn(5)
          @three_seven.computers_fourth_turn
          expect(@three_seven.gamespot(4).player).to eq('X')
        end
      end

      context "when x has positions 3 and 9" do
        before :each do
          @three_nine = create(:corner_game)
          @three_nine.human_turn(7)
          @three_nine.computers_second_turn
          @three_nine.human_turn(2)
          @three_nine.computers_third_turn
        end

        it 'plays position 5 to win diagonally if it can' do
          @three_nine.human_turn(6)
          @three_nine.computers_fourth_turn
          expect(@three_nine.gamespot(5).player).to eq('X')
        end

        it "plays position 6 to win vertically if it can't win diagonally" do
          @three_nine.human_turn(5)
          @three_nine.computers_fourth_turn
          expect(@three_nine.gamespot(6).player).to eq('X')
        end
      end

      context "when x has positions 7 and 9" do
        before :each do
          @seven_nine = create(:x_has_7)
          @seven_nine.computers_second_turn
          @seven_nine.human_turn(4)
          @seven_nine.computers_third_turn
        end

        it 'plays position 5 to win diagonally if it can' do
          @seven_nine.human_turn(6)
          @seven_nine.computers_fourth_turn
          expect(@seven_nine.gamespot(5).player).to eq('X')
        end

        it "plays position 8 to win horizontally if it can't win diagonally" do
          @seven_nine.human_turn(5)
          @seven_nine.computers_fourth_turn
          expect(@seven_nine.gamespot(8).player).to eq('X')
        end
      end
    end
  end


  #   context "on it's fourth turn" do

  #     context 'when the computer has the opposite corners' do
  #       before :each do
  #         @opposites = create(:opposites)
  #         @opposites.computers_second_turn
  #         @opposites.human_turn(5)
  #         @opposites.computers_third_turn
  #       end

  #       it 'plays X in position 4 to win vertically if it can' do
  #         @opposites.human_turn(8)
  #         @opposites.computers_fourth_turn
  #         expect(@opposites.spots.where(position: 4).first.player).to eq('X')
  #       end

  #       it "plays X in position 8 to win horizontally if it can't win vertically" do
  #         @opposites.human_turn(4)
  #         @opposites.computers_fourth_turn
  #         expect(@opposites.spots.where(position: 8).first.player).to eq('X')
  #       end
  #     end

  #     # context 'where the computer has spots 1 and 7' do
  #     #   before :each do
  #     #     @game.human_turn(9)
  #     #     @game.computers_second_turn
  #     #     @game.human_turn(4)
  #     #     @game.computers_third_turn
  #     #   end

  #     #   it 'plays X in the top-middle spot (position 2) to win horizontally if it can' do
  #     #     @game.human_turn(5)
  #     #     @game.computers_fourth_turn
  #     #     expect(@game.spots.where(position: 2).first.player).to eq('X')
  #     #   end

  #     #   it "plays X in the middle spot (position 5) to win diagonally if it can't win horizontally" do
  #     #     @game.human_turn(2)
  #     #     @game.computers_fourth_turn
  #     #     expect(@game.spots.where(position: 5).first.player).to eq('X')
  #     #   end
  #     # end
  #   end
  # end


  # describe 'the computer playing a peninsula game' do
  #   context "on its second turn" do

  #   end

  #   context "on it's third turn" do

  #   end

  #   context "on it's fourth turn" do

  #   end
  # end











# ORIGINAL GAME_SPEC BELOW






  # describe 'the computers second turn' do
  #   context 'in a middle game' do
  #     it 'plays X in the top-middle spot (position 2)' do
  #       game = create(:middle_game)
  #       game.computers_second_turn
  #       expect(game.spots.where(position: 2).first.player).to eq('X')
  #     end
  #   end

  #   context 'in a corner game' do
  #     it 'plays X in the bottom-right spot (position 9) if it is available' do
  #       game = create(:corner_game)
  #       game.human_turn(7)
  #       game.computers_second_turn
  #       expect(game.spots.where(position: 9).first.player).to eq('X')
  #     end

  #     it 'plays X in the bottom-left spot (position 7) if spot 9 is taken' do
  #       game = create(:corner_game)
  #       game.human_turn(9)
  #       game.computers_second_turn
  #       expect(game.spots.where(position: 7).first.player).to eq('X')
  #     end
  #   end

  #   context 'in a peninsula game' do
  #     it 'plays X in the middle spot (position 5)' do
  #       game = create(:peninsula_game)
  #       game.computers_second_turn
  #       expect(game.spots.where(position: 5).first.player).to eq('X')
  #     end
  #   end
  # end

  # describe 'the computers third turn' do
  #   context 'in a middle game' do
  #     before :each do
  #       @game = create(:middle_game)
  #       @game.computers_second_turn
  #     end

  #     it 'plays X in the top-right spot (position 3) to win if it can' do
  #       @game.human_turn(8)
  #       @game.computers_third_turn
  #       expect(@game.spots.where(position: 3).first.player).to eq('X')
  #     end

  #     it "plays X in the bottom-left corner (position 7) if it can't win" do
  #       @game.human_turn(3)
  #       @game.computers_third_turn
  #       expect(@game.spots.where(position: 7).first.player).to eq('X')
  #     end
  #   end

  #   context 'in a corner game' do
  #     before :each do
  #       @game = create(:corner_game)
  #     end

      # context 'where the computer has the opposite corners' do
      #   before :each do
      #     @game.human_turn(7)
      #     @game.computers_second_turn
      #   end

      #   it 'plays the middle spot (5) to win if it can' do
      #     @game.human_turn(2)
      #     @game.computers_third_turn
      #     expect(@game.spots.where(position: 5).first.player).to eq('X')
      #   end

      #   it "plays the last remaining corner if it can't win" do
      #     @game.human_turn(5)
      #     @game.computers_third_turn
      #     expect(@game.spots.where(position: 3).first.player).to eq('X')
      #   end
      # end

      # context 'where the computer has spots 1 and 7' do
      #   before :each do
      #     @game.human_turn(9)
      #     @game.computers_second_turn
      #   end

      #   it 'plays the middle-left spot (position 4) to win if it can' do
      #     @game.human_turn(6)
      #     @game.computers_third_turn
      #     expect(@game.spots.where(position: 4).first.player).to eq('X')
      #   end

      #   it "plays the top-left spot (position 3) if it can't win" do
      #     @game.human_turn(4)
      #     @game.computers_third_turn
      #     expect(@game.spots.where(position: 3).first.player).to eq('X')
      #   end
      # end
  #   end

  #   context 'in a peninsula game' do
  #     before :each do
  #       @game = create(:peninsula_game)
  #     end

  #     it 'plays the bottom-right spot (position 9) to win if it can' do
  #       @game.human_turn(2)
  #       @game.computers_second_turn
  #       @game.human_turn(8)
  #       @game.computers_third_turn
  #       expect(@game.spots.where(position: 9).first.player).to eq('X')
  #     end

  #     context 'where the human has a middle-column spot (position 2 or 8)' do
  #       it 'plays the bottom-left spot (position 7)' do
  #         @game.human_turn(2)
  #         @game.computers_second_turn
  #         @game.human_turn(9)
  #         @game.computers_third_turn
  #         expect(@game.spots.where(position: 7).first.player).to eq('X')
  #       end
  #     end

  #     context 'where the human has a middle-row spot (position 4 or 6)' do
  #       it 'plays the top-right spot (position 3)' do
  #         @game.human_turn(4)
  #         @game.computers_second_turn
  #         @game.human_turn(9)
  #         @game.computers_third_turn
  #         expect(@game.spots.where(position: 3).first.player).to eq('X')
  #       end
  #     end
  #   end
  # end

  # describe 'the computers fourth turn' do
  #   context 'in a middle game' do
  #     before :each do
  #       @game = create(:middle_game)
  #       @game.computers_second_turn
  #       @game.human_turn(3)
  #       @game.computers_third_turn
  #     end

  #     it 'plays X in the middle-left spot (position 4) to win if it can' do
  #       @game.human_turn(9)
  #       @game.computers_fourth_turn
  #       expect(@game.spots.where(position: 4).first.player).to eq('X')
  #     end

  #     it "plays X in the middle-right corner (position 6) to block if it can't win" do
  #       @game.human_turn(4)
  #       @game.computers_fourth_turn
  #       expect(@game.spots.where(position: 6).first.player).to eq('X')
  #     end
  #   end

  #   context 'in a corner game' do
  #     before :each do
  #       @game = create(:corner_game)
  #     end

  #     context 'where the computer has the opposite corners' do
  #       before :each do
  #         @game.human_turn(3)
  #         @game.computers_second_turn
  #         @game.human_turn(5)
  #         @game.computers_third_turn
  #       end

  #       it 'plays X in the middle-left spot (position 4) to win if it can' do
  #         @game.human_turn(8)
  #         @game.computers_fourth_turn
  #         expect(@game.spots.where(position: 4).first.player).to eq('X')
  #       end

  #       it "plays X in the bottom-middle spot (position 8) to win if it can't win vertically" do
  #         @game.human_turn(4)
  #         @game.computers_fourth_turn
  #         expect(@game.spots.where(position: 8).first.player).to eq('X')
  #       end
  #     end

  #     context 'where the computer has spots 1 and 7' do
  #       before :each do
  #         @game.human_turn(9)
  #         @game.computers_second_turn
  #         @game.human_turn(4)
  #         @game.computers_third_turn
  #       end

  #       it 'plays X in the top-middle spot (position 2) to win horizontally if it can' do
  #         @game.human_turn(5)
  #         @game.computers_fourth_turn
  #         expect(@game.spots.where(position: 2).first.player).to eq('X')
  #       end

  #       it "plays X in the middle spot (position 5) to win diagonally if it can't win horizontally" do
  #         @game.human_turn(2)
  #         @game.computers_fourth_turn
  #         expect(@game.spots.where(position: 5).first.player).to eq('X')
  #       end
  #     end
  #   end

  #   context 'in a peninsula game' do
  #     before :each do
  #       @game = create(:peninsula_game)
  #     end

  #     context 'where the computer has position 7' do
  #       it 'plays position 3 to win diagonally if it can' do
  #         @game.human_turn(2)
  #         @game.computers_second_turn
  #         @game.human_turn(9)
  #         @game.computers_third_turn
  #         @game.human_turn(4)
  #         @game.computers_fourth_turn
  #         expect(@game.spots.where(position: 3).first.player).to eq('X')
  #       end

  #       it "plays position 4 to win vertically if it can't win diagonally" do
  #         @game.human_turn(2)
  #         @game.computers_second_turn
  #         @game.human_turn(9)
  #         @game.computers_third_turn
  #         @game.human_turn(3)
  #         @game.computers_fourth_turn
  #         expect(@game.spots.where(position:4).first.player).to eq('X')
  #       end
  #     end

  #     context 'where the computer has position 3' do
  #       it 'plays position 7 to win diagonally if it can' do
  #         @game.human_turn(4)
  #         @game.computers_second_turn
  #         @game.human_turn(9)
  #         @game.computers_third_turn
  #         @game.human_turn(2)
  #         @game.computers_fourth_turn
  #         expect(@game.spots.where(position: 7).first.player).to eq('X')
  #       end

  #       it "plays position 2 to win horizontally if it can't win diagonally" do
  #         @game.human_turn(4)
  #         @game.computers_second_turn
  #         @game.human_turn(9)
  #         @game.computers_third_turn
  #         @game.human_turn(7)
  #         @game.computers_fourth_turn
  #         expect(@game.spots.where(position: 2).first.player).to eq('X')
  #       end
  #     end
  #   end
  # end

  # describe 'the computers fifth turn' do
  #   it 'plays the last available spot' do
  #     game = create(:middle_game)
  #     game.spots.where(position: 1).first.player = 'X'
  #     game.human_turn(5)
  #     game.computers_second_turn
  #     game.human_turn(3)
  #     game.computers_third_turn
  #     game.human_turn(4)
  #     game.computers_fourth_turn
  #     game.human_turn(8)
  #     game.computers_fifth_turn
  #     expect(game.spots.where(player: nil).count).to eq(0)
  #   end
  # end

  # describe 'checking status' do
  #   it 'ends the game when the computer wins horizontally' do
  #     game = create(:game)
  #     game.spots.where('position = ? OR position = ? OR position = ?', 1, 2, 3).each do |spot|
  #       spot.player = 'X'
  #       spot.save
  #     end
  #     game.check_status
  #     expect(game.status).to eq('over')
  #   end

  #   it 'ends the game when the computer wins vertically' do
  #     game = create(:game)
  #     game.spots.where('position = ? OR position = ? OR position = ?', 3, 6, 9).each do |spot|
  #       spot.player = 'X'
  #       spot.save
  #     end
  #     game.check_status
  #     expect(game.status).to eq('over')
  #   end

  #   it 'ends the game when the computer wins diagonally 1-5-9' do
  #     game = create(:game)
  #     game.spots.where('position = ? OR position = ? OR position = ?', 1, 5, 9).each do |spot|
  #       spot.player = 'X'
  #       spot.save
  #     end
  #     game.check_status
  #     expect(game.status).to eq('over')
  #   end

  #   it 'ends the game when the computer wins diagonally 3-5-7' do
  #     game = create(:game)
  #     game.spots.where('position = ? OR position = ? OR position = ?', 3, 5, 7).each do |spot|
  #       spot.player = 'X'
  #       spot.save
  #     end
  #     game.check_status
  #     expect(game.status).to eq('over')
  #   end

  #   it 'ends the game when there are no positions left to play' do
  #     players = ['X', 'O']
  #     game = create(:game)
  #     game.spots.each do |spot|
  #       spot.player = players.sample
  #       spot.save
  #     end
  #     game.check_status
  #     expect(game.status).to eq('over')
  #   end
  # end

end
