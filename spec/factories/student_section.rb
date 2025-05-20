FactoryBot.define do
  factory :student_section do
    association :student
    association :section
  end
end