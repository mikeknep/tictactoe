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

end
