FactoryBot.define do
  factory :reservation do
    book
    user
    returned_on { nil }

    trait :returned do
      returned_on { Date.today }
    end
  end
end
