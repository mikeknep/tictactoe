module GamesHelper

  def spot_status(position)
    spot = Spot.where(position: position).where(game: @game).first

    if spot.player.nil?
      if @game.status == 'in_progress'
        render partial: 'games/playable_spot_form', locals: { position: position }
      end
    else
      spot.player
    end
  end

end
