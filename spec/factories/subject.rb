FactoryBot.define do
  factory :subject do
    name { Faker::Educator.course_name }
  end
end