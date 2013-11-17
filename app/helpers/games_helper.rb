module GamesHelper

  def spot_status(position, game_id, turn)
    spot = Spot.where(position: position).where(game_id: game_id).first
    if spot.player.nil?
      render partial: 'games/playable_spot_form', locals: { t: turn, game_id: game_id, position: position }
    else
      spot.player
    end
  end

end
