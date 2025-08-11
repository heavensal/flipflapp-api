FactoryBot.define do
  factory :event do
    title { Faker::Lorem.words(3).join(' ') }
    description { Faker::Lorem.paragraph }
    location { Faker::Address.full_address }
    start_time { 1.day.from_now }
    number_of_participants { 10 }
    price { 25.0 }
    is_private { false }
    association :user
  end
end