FactoryGirl.define do
  factory :game do
    status 'in_progress'
    human_turns 0

    factory :corner_game do
      gametype 'corner'
    end

    factory :peninsula_game do
      gametype 'peninsula'
    end

    factory :middle_game do
      gametype 'middle'
    end
  end
end
