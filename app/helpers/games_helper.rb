module GamesHelper

  def spot_status(position)
    spot = Spot.where(position: position).where(game: @game).first

    if spot.player.nil?
      if @game.status == 'in_progress'
        render partial: 'games/playable_spot_form', locals: { position: position }
      end
    else
      player_token(spot)
    end
  end

  def player_token(spot)
    case spot.player
    when 1
      'X'
    when 2
      'O'
    end
  end

  def square_class(i)
    winning_array = Array.new
    player_1_spots = @game.spots.where(player: 1).map{ |s| s.position }.to_set
    player_2_spots = @game.spots.where(player: 2).map{ |s| s.position }.to_set
    all_victories = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]].map{ |a| a.to_set }
    all_victories.each do |set|
      if set.subset?(player_1_spots) || set.subset?(player_2_spots)
        winning_array = set.to_a
      end
    end

    if @game.status == "loss" && winning_array.include?(i)
      "square victory"
    else
      "square"
    end
  end

end
