FactoryGirl.define do
  factory :game do
    status 'in_progress'
    human_turns 0
    sequence(:user_id)

    after(:create) do |game|
      9.times {|i| Spot.create(game_id: game.id, position: i+1)}
    end

    after(:create) do |game|
      game.computers_first_turn
    end


    factory :corner_game do
      gametype 'corner'
      human_turns 1

      factory :x_has_3 do
        after(:create) {|game| game.human_turn(9)}
      end

      factory :x_has_7 do
        after(:create) {|game| game.human_turn(3)}
      end
    end


    factory :peninsula_game do
      gametype 'peninsula'
      human_turns 1

      factory :o_took_2 do
        after(:create) {|game| game.human_turn(2)}
      end

      factory :o_took_4 do
        after(:create) {|game| game.human_turn(4)}
      end
    end


    factory :middle_game do
      after(:create) {|game| game.human_turn(5)}
      gametype 'middle'
      human_turns 1
    end
  end
end
