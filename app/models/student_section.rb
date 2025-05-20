class StudentSection < ApplicationRecord
  belongs_to :student
  belongs_to :section
  validates :student_id, uniqueness: { scope: :section_id }
end