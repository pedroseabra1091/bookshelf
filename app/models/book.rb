class Book < ApplicationRecord
  enum genre: {
    software_engineering: 0,
    science_fiction: 1,
    thriller: 2,
    horror_fiction: 3,
    finances: 4,
    self_help: 5
  }
end
