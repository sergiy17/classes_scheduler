class Section < ApplicationRecord
  belongs_to :teacher
  belongs_to :subject
  belongs_to :classroom
  has_many :student_sections, dependent: :destroy
  has_many :students, through: :student_sections

  validates :start_time, :end_time, presence: true
  validates :days, presence: true, inclusion: {
    in: %w[Monday Tuesday Wednesday Thursday Friday],
    message: "must be a weekday"
  }
end