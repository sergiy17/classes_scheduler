require 'rails_helper'

RSpec.describe Section, type: :model do
  describe 'associations' do
    it 'belongs to a teacher' do
      teacher = create(:teacher)
      section = create(:section, teacher: teacher)
      expect(section.teacher).to eq(teacher)
    end

    it 'belongs to a subject' do
      subject = create(:subject)
      section = create(:section, subject: subject)
      expect(section.subject).to eq(subject)
    end

    it 'belongs to a classroom' do
      classroom = create(:classroom)
      section = create(:section, classroom: classroom)
      expect(section.classroom).to eq(classroom)
    end

    it 'has many student_sections that are destroyed when section is destroyed' do
      section = create(:section)
      create(:student_section, section: section)
      expect { section.destroy }.to change { StudentSection.count }.by(-1)
    end

    it 'has many students through student_sections' do
      section = create(:section)
      student = create(:student)
      create(:student_section, section: section, student: student)
      expect(section.students).to include(student)
    end
  end

  describe 'validations' do
    let(:section) { build(:section) }

    it 'requires start_time' do
      section.start_time = nil
      expect(section).not_to be_valid
      expect(section.errors[:start_time]).to include("can't be blank")
    end

    it 'requires end_time' do
      section.end_time = nil
      expect(section).not_to be_valid
      expect(section.errors[:end_time]).to include("can't be blank")
    end

    it 'requires days' do
      section.days = []
      expect(section).not_to be_valid
      expect(section.errors[:days]).to include("can't be blank")
    end

    describe 'days inclusion' do
      it 'is valid with allowed weekdays' do
        section.days = %w[Monday Tuesday]
        expect(section).to be_valid
      end

      it 'is invalid with non-weekday values' do
        section.days = %w[Saturday Sunday]
        expect(section).not_to be_valid
        expect(section.errors[:days]).to include('must be a weekday')
      end
    end

    describe 'valid_section_duration' do
      it 'is valid with 50-minute duration' do
        section.start_time = Time.parse('08:00')
        section.end_time = Time.parse('08:50')
        expect(section).to be_valid
      end

      it 'is valid with 80-minute duration' do
        section.start_time = Time.parse('09:00')
        section.end_time = Time.parse('10:20')
        expect(section).to be_valid
      end

      it 'is invalid with other durations' do
        section.start_time = Time.parse('08:00')
        section.end_time = Time.parse('09:00')
        expect(section).not_to be_valid
        expect(section.errors[:base]).to include('Section duration must be 50 or 80 minutes')
      end
    end

    describe 'valid_section_start' do
      it 'is valid when start time is at or after 7:30 AM' do
        section.start_time = Time.parse('07:30')
        section.end_time = Time.parse('08:20')
        expect(section).to be_valid
      end

      it 'is invalid when start time is before 7:30 AM' do
        section.start_time = Time.parse('07:00')
        section.end_time = Time.parse('07:50')
        expect(section).not_to be_valid
        expect(section.errors[:base]).to include('Section must start after 7:30')
      end
    end

    describe 'valid_section_end' do
      it 'is valid when end time is at or before 10:00 PM' do
        section.start_time = Time.parse('21:10')
        section.end_time = Time.parse('22:00')
        expect(section).to be_valid
      end

      it 'is invalid when end time is after 10:00 PM' do
        section.start_time = Time.parse('21:30')
        section.end_time = Time.parse('22:10')
        expect(section).not_to be_valid
        expect(section.errors[:base]).to include('Section must finish before 22:00')
      end
    end
  end
end
