require 'rails_helper'

RSpec.describe StudentSection, type: :model do
  describe 'associations' do
    it 'belongs to a student' do
      student = create(:student)
      student_section = create(:student_section, student: student)
      expect(student_section.student).to eq(student)
    end

    it 'belongs to a section' do
      section = create(:section)
      student_section = create(:student_section, section: section)
      expect(student_section.section).to eq(section)
    end
  end

  describe 'validations' do
    let(:student) { create(:student) }
    let(:section) { create(:section) }

    it 'validates uniqueness of student_id scoped to section_id' do
      create(:student_section, student: student, section: section)
      duplicate = build(:student_section, student: student, section: section)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:student_id]).to include('has already been taken')
    end
  end
end