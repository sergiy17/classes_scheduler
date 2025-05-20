FactoryBot.define do
  factory :section do
    association :teacher
    association :subject
    association :classroom
    start_time { Time.parse("08:00") }
    end_time { Time.parse("08:50") }
    days { %w[Monday Wednesday Friday] }
  end
end