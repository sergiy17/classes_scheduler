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

  validate :valid_section_duration
  validate :valid_section_start
  validate :valid_section_end

  private

  def valid_section_duration
    return unless start_time && end_time

    duration = (end_time - start_time) / 60
    errors.add(:base, "Section duration must be 50 or 80 minutes") unless [50, 80].include?(duration)
  end

  def valid_section_start
    return unless start_time && end_time

    earliest_time = Time.parse("07:30")
    errors.add(:base, "Section must start after 7:30") if start_time < earliest_time
  end

  def valid_section_end
    return unless start_time && end_time

    latest_time = Time.parse("22:00")
    errors.add(:base, "Section must finish before 22:00") if end_time > latest_time
  end
end