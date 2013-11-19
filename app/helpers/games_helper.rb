module GamesHelper

  def spot_status(position, game_id, turn)
    game = Game.find(game_id)
    spot = Spot.where(position: position).where(game_id: game_id).first


    if spot.player.nil?
      if game.status == 'in_progress'
        render partial: 'games/playable_spot_form', locals: { t: turn, game_id: game_id, position: position }
      end
    else
      spot.player
    end
  end

end
