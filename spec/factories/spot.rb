FactoryGirl.define do
  factory :spot do
    sequence(:position)
    # association :game  FIXME: Something about the game's after_create build_game_board is giving this trouble
    sequence(:game_id)

    factory :computer_spot do
      player 'X'
    end

    factory :human_spot do
      player 'O'
    end

  end
end
