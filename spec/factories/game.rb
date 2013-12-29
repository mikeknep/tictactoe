FactoryGirl.define do
  factory :game do
    status 'in_progress'
    sequence(:user_id)

    after(:create) do |game|
      game.build_game_board
      game.save
    end

  end
end
