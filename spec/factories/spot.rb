FactoryGirl.define do
  factory :spot do
    association :game

    factory :computer_spot do
      player 'x'
    end

    factory :human_spot do
      player 'o'
    end

  end
end
