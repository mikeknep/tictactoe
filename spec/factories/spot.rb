FactoryGirl.define do
  factory :spot do
    position { rand(1..9) }
    sequence(:game_id)

    factory :computer_spot do
      player 'X'
    end

    factory :human_spot do
      player 'O'
    end

  end
end
