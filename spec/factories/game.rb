FactoryGirl.define do
  factory :game do
    status 'in_progress'
    sequence(:user_id)

    after(:create) do |game|
      9.times {|i| Spot.create(game_id: game.id, position: i+1)}
    end

  end
end
