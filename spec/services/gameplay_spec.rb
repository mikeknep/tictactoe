require 'spec_helper'

describe Gameplay do

  it "saves the human's turn" do
    pending
    human_turn method
  end

  describe "assessing and playing the best moves for the computer" do
    pending('this whole thing is getting revamped')
    # old tests below
  end

  describe "assessing the status of the game / checking for victory" do
    pending('this will get reworked a bit')
    # old tests below
  end




end # This is the FINAL end, terminating the entire 'describe Gameplay do' block




#
# Old tests from models/game_spec.rb re: checking status
#

# describe 'checking status' do
#   context 'ends the game when the computer wins horizontally' do
#     it '1-2-3' do
#       game = create(:game)
#       game.spots.where(position: [1, 2, 3]).each do |spot|
#         spot.player = 'X'
#         spot.save
#       end
#       game.check_status
#       expect(game.status).to eq('over')
#     end

#     it '4-5-6' do
#       game = create(:game)
#       game.spots.where(position: [4, 5, 6]).each do |spot|
#         spot.player = 'X'
#         spot.save
#       end
#       game.check_status
#       expect(game.status).to eq('over')
#     end

#     it '7-8-9' do
#       game = create(:game)
#       game.spots.where(position: [7, 8, 9]).each do |spot|
#         spot.player = 'X'
#         spot.save
#       end
#       game.check_status
#       expect(game.status).to eq('over')
#     end
#   end

#   context 'ends the game when the computer wins vertically' do
#     it '1-4-7' do
#       game = create(:game)
#       game.spots.where(position: [1, 4, 7]).each do |spot|
#         spot.player = 'X'
#         spot.save
#       end
#       game.check_status
#       expect(game.status).to eq('over')
#     end

#     it '2-5-8' do
#       game = create(:game)
#       game.spots.where(position: [2, 5, 8]).each do |spot|
#         spot.player = 'X'
#         spot.save
#       end
#       game.check_status
#       expect(game.status).to eq('over')
#     end

#     it '3-6-9' do
#       game = create(:game)
#       game.spots.where(position: [3, 6, 9]).each do |spot|
#         spot.player = 'X'
#         spot.save
#       end
#       game.check_status
#       expect(game.status).to eq('over')
#     end
#   end

#   context 'ends the game when the computer wins diagonally' do
#     it '1-5-9' do
#       game = create(:game)
#       game.spots.where(position: [1, 5, 9]).each do |spot|
#         spot.player = 'X'
#         spot.save
#       end
#       game.check_status
#       expect(game.status).to eq('over')
#     end

#     it '3-5-7' do
#       game = create(:game)
#       game.spots.where(position: [3, 5, 7]).each do |spot|
#         spot.player = 'X'
#         spot.save
#       end
#       game.check_status
#       expect(game.status).to eq('over')
#     end
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




#
# Old tests from models/game_spec.rb outlining computer logic
#

# describe 'the computer playing a middle game' do
#   before :each do
#     @game = create(:middle_game)
#   end

#   context "on its second turn" do
#     it 'plays X in position 2' do
#       @game.computers_second_turn
#       expect(@game.gamespot(2).player).to eq('X')
#     end
#   end

#   context "on it's third turn" do
#     before :each do
#       @game.computers_second_turn
#     end

#     it 'plays X in position 3 to win if it can' do
#       @game.human_turn(8)
#       @game.computers_third_turn
#       expect(@game.gamespot(3).player).to eq('X')
#     end

#     it "plays X in position 7 if it can't win" do
#       @game.human_turn(3)
#       @game.computers_third_turn
#       expect(@game.gamespot(7).player).to eq('X')
#     end
#   end

#   context "on it's fourth turn" do
#     before :each do
#       @game.computers_second_turn
#       @game.human_turn(3)
#       @game.computers_third_turn
#     end

#     it 'plays X in position 4 to win if it can' do
#       @game.human_turn(9)
#       @game.computers_fourth_turn
#       expect(@game.gamespot(4).player).to eq('X')
#     end

#     it "plays X in position 6 to block if it can't win" do
#       @game.human_turn(4)
#       @game.computers_fourth_turn
#       expect(@game.gamespot(6).player).to eq('X')
#     end
#   end

#   context "on it's fifth turn" do
#     before :each do
#       @game.computers_second_turn
#       @game.human_turn(3)
#       @game.computers_third_turn
#       @game.human_turn(4)
#       @game.computers_fourth_turn
#     end

#     it 'plays the last remaining position' do
#       @game.human_turn(8)
#       @game.computers_fifth_turn
#       expect(@game.spots.where(player: nil).count).to eq(0)
#     end
#   end
# end


# describe 'the computer playing a corner game' do
#   context "on its second turn" do
#     before :each do
#       @corner_game = create(:corner_game)
#     end

#     it 'plays X in position 3 if it is available' do
#       @corner_game.human_turn(9)
#       @corner_game.computers_second_turn
#       expect(@corner_game.gamespot(3).player).to eq('X')
#     end

#     it 'plays X in position 7 if spot 3 is taken' do
#       @corner_game.human_turn(3)
#       @corner_game.computers_second_turn
#       expect(@corner_game.gamespot(7).player).to eq('X')
#     end
#   end

#   context "on it's third turn" do
#     context "when x has position 3" do
#       before :each do
#         @x_has_3 = create(:x_has_3)
#         @x_has_3.computers_second_turn
#       end

#       it 'plays X in position 2 to win if it is available' do
#         @x_has_3.human_turn(8)
#         @x_has_3.computers_third_turn
#         expect(@x_has_3.gamespot(2).player).to eq('X')
#       end

#       it "plays X in the last available corner if it can't win" do
#         @x_has_3.human_turn(2)
#         @x_has_3.computers_third_turn
#         expect(@x_has_3.gamespot(7).player).to eq('X')
#       end
#     end

#     context "when x has position 7" do
#       before :each do
#         @x_has_7 = create(:x_has_7)
#         @x_has_7.computers_second_turn
#       end

#       it 'plays X in position 4 to win if it is available' do
#         @x_has_7.human_turn(6)
#         @x_has_7.computers_third_turn
#         expect(@x_has_7.gamespot(4).player).to eq('X')
#       end

#       it "plays X in the last available corner if it can't win" do
#         @x_has_7.human_turn(4)
#         @x_has_7.computers_third_turn
#         expect(@x_has_7.gamespot(9).player).to eq('X')
#       end
#     end
#   end

#   context "on it's fourth turn" do
#     context "when x has positions 3 and 7" do
#       before :each do
#         @three_seven = create(:x_has_3)
#         @three_seven.computers_second_turn
#         @three_seven.human_turn(2)
#         @three_seven.computers_third_turn
#       end

#       it 'plays position 5 to win diagonally if it can' do
#         @three_seven.human_turn(6)
#         @three_seven.computers_fourth_turn
#         expect(@three_seven.gamespot(5).player).to eq('X')
#       end

#       it "plays position 4 to win vertically if it can't win diagonally" do
#         @three_seven.human_turn(5)
#         @three_seven.computers_fourth_turn
#         expect(@three_seven.gamespot(4).player).to eq('X')
#       end
#     end

#     context "when x has positions 3 and 9" do
#       before :each do
#         @three_nine = create(:corner_game)
#         @three_nine.human_turn(7)
#         @three_nine.computers_second_turn
#         @three_nine.human_turn(2)
#         @three_nine.computers_third_turn
#       end

#       it 'plays position 5 to win diagonally if it can' do
#         @three_nine.human_turn(6)
#         @three_nine.computers_fourth_turn
#         expect(@three_nine.gamespot(5).player).to eq('X')
#       end

#       it "plays position 6 to win vertically if it can't win diagonally" do
#         @three_nine.human_turn(5)
#         @three_nine.computers_fourth_turn
#         expect(@three_nine.gamespot(6).player).to eq('X')
#       end
#     end

#     context "when x has positions 7 and 9" do
#       before :each do
#         @seven_nine = create(:x_has_7)
#         @seven_nine.computers_second_turn
#         @seven_nine.human_turn(4)
#         @seven_nine.computers_third_turn
#       end

#       it 'plays position 5 to win diagonally if it can' do
#         @seven_nine.human_turn(6)
#         @seven_nine.computers_fourth_turn
#         expect(@seven_nine.gamespot(5).player).to eq('X')
#       end

#       it "plays position 8 to win horizontally if it can't win diagonally" do
#         @seven_nine.human_turn(5)
#         @seven_nine.computers_fourth_turn
#         expect(@seven_nine.gamespot(8).player).to eq('X')
#       end
#     end
#   end
# end


# describe 'the computer playing a peninsula game' do
#   context "on its second turn" do
#     it 'plays X in position 5' do
#       game = create(:peninsula_game)
#       game.computers_second_turn
#       expect(game.gamespot(5).player).to eq('X')
#     end
#   end

#   context "on it's third turn" do
#     before :each do
#       @o_took_2 = create(:o_took_2)
#       @o_took_2.computers_second_turn
#     end

#     it 'plays position 9 to win if it can' do
#       @o_took_2.human_turn(4)
#       @o_took_2.computers_third_turn
#       expect(@o_took_2.gamespot(9).player).to eq('X')
#     end

#     it 'plays position 7 when the human has a middle-column spot (2 or 8)' do
#       @o_took_2.human_turn(9)
#       @o_took_2.computers_third_turn
#       expect(@o_took_2.gamespot(7).player).to eq('X')
#     end

#     it 'plays position 3 when the human has a middle-row spot (4 or 6)' do
#       o_took_4 = create(:o_took_4)
#       o_took_4.computers_second_turn
#       o_took_4.human_turn(9)
#       o_took_4.computers_third_turn
#       expect(o_took_4.gamespot(3).player).to eq('X')
#     end
#   end

#   context "on it's fourth turn" do
#     context "when x has position 7" do
#       before :each do
#         @game = create(:o_took_2)
#         @game.computers_second_turn
#         @game.human_turn(9)
#         @game.computers_third_turn
#       end

#       it 'plays position 3 to win diagonally if it can' do
#         @game.human_turn(4)
#         @game.computers_fourth_turn
#         expect(@game.gamespot(3).player).to eq('X')
#       end

#       it "plays position 4 to win vertically if it can't win diagonally" do
#         @game.human_turn(3)
#         @game.computers_fourth_turn
#         expect(@game.gamespot(4).player).to eq('X')
#       end
#     end

#     context "when x has position 3" do
#       before :each do
#         @game = create(:o_took_4)
#         @game.computers_second_turn
#         @game.human_turn(9)
#         @game.computers_third_turn
#       end

#       it 'plays position 7 to win diagonally if it can' do
#         @game.human_turn(2)
#         @game.computers_fourth_turn
#         expect(@game.gamespot(7).player).to eq('X')
#       end

#       it "plays position 2 to win horizontally if it can't win diagonally" do
#         @game.human_turn(7)
#         @game.computers_fourth_turn
#         expect(@game.gamespot(2).player).to eq('X')
#       end
#     end
#   end
# end
