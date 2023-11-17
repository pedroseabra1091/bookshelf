FactoryBot.define do
  factory :book do
    title { FFaker::Book.title }
    genre { Book.genres.keys.sample }
    description { FFaker::Book.description }
    cover_url { FFaker::Book.cover }
    price { FFaker::Number.decimal }
  end
end
