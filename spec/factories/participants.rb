FactoryBot.define do
  factory :participant do
    team { 'team_a' }
    association :user
    association :event
  end
end