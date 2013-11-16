FactoryGirl.define do
  factory :game do
    status 'in_progress'
    number_of_turns 0

    factory :corner_game do
      opponents_first_spot_type 'corner'
    end

    factory :peninsula_game do
      opponents_first_spot_type 'peninsula'
    end

    factory :middle_game do
      opponents_first_spot_type 'middle'
    end
  end
end
