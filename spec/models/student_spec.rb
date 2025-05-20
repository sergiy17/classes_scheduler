require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'associations' do
    it 'has many student_sections that are destroyed when student is destroyed' do
      student = create(:student)
      create(:student_section, student: student)
      expect { student.destroy }.to change { StudentSection.count }.by(-1)
    end

    it 'has many sections through student_sections' do
      student = create(:student)
      section = create(:section)
      create(:student_section, student: student, section: section)
      expect(student.sections).to include(section)
    end
  end

  describe 'validations' do
    it 'requires name' do
      student = build(:student, name: nil)
      expect(student).not_to be_valid
      expect(student.errors[:name]).to include("can't be blank")
    end
  end
end