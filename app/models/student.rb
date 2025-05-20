class Student < ApplicationRecord
  has_many :student_sections, dependent: :destroy
  has_many :sections, through: :student_sections
  validates :name, presence: true

  def add_section(section)
    return false if section_conflicts?(section)

    student_sections.create(section: section)
  end

  def remove_section(section)
    student_sections.find_by(section: section)&.destroy
  end

  def schedule
    sections.includes(:subject, :teacher, :classroom)
  end

  private

  def section_conflicts?(new_section)
    sections.any? do |existing_section|
      overlapping_days?(existing_section, new_section) &&
        overlapping_times?(existing_section, new_section)
    end
  end

  def overlapping_days?(section1, section2)
    (section1.days & section2.days).any?
  end

  def overlapping_times?(section1, section2)
    section1.start_time < section2.end_time && section2.start_time < section1.end_time
  end
end