class Book < ApplicationRecord
  enum genre: {
    software_engineering: 0,
    science_fiction: 1,
    thriller: 2,
    horror_fiction: 3,
    finances: 4,
    self_help: 5
  }

  validates :title, :price, :cover_url, presence: true
  validates :price, numericality: { greater_than: 0 }
end
