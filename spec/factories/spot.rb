FactoryGirl.define do
  factory :spot do
    position { rand(1..9) }
    sequence(:game_id)

    factory :computer_spot do
      player 1
    end

    factory :human_spot do
      player 2
    end

  end
end
