FactoryBot.define do
  factory :friendship do
    association :user
    association :friend, factory: :user
    status { 'accepted' }
  end
end