FactoryGirl.define do
  factory :spot do
    position { rand(1..9) }
    sequence(:game_id)
    player 1
  end
end
