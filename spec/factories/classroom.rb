FactoryBot.define do
  factory :classroom do
    name { "Room #{Faker::Number.unique.between(from: 100, to: 999)}" }
  end
end