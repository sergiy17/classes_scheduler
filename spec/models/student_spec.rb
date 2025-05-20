require 'rails_helper'

RSpec.describe Student, type: :model do
  let(:student) { create(:student) }
  let(:section) { create(:section, start_time: Time.parse('08:00'), end_time: Time.parse('08:50'), days: %w[Monday Wednesday Friday]) }

  describe 'associations' do
    it 'has many student_sections that are destroyed when student is destroyed' do
      create(:student_section, student: student)
      expect { student.destroy }.to change { StudentSection.count }.by(-1)
    end

    it 'has many sections through student_sections' do
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

  describe '#add_section' do
    context 'when there is no time conflict' do
      it 'adds the section to the student’s schedule' do
        expect { student.add_section(section) }.to change { student.sections.count }.by(1)
        expect(student.reload.sections).to include(section)
      end
    end

    context 'when there is a time conflict' do
      let(:conflicting_section) { create(:section, start_time: Time.parse('08:00'), end_time: Time.parse('08:50'), days: %w[Monday Wednesday Friday]) }

      before do
        student.sections.destroy_all
        student.add_section(section)
      end

      it 'does not add the section and returns false' do
        expect(student.reload.add_section(conflicting_section)).to be false
        expect(student.reload.sections).not_to include(conflicting_section)
      end
    end
  end

  describe '#remove_section' do
    context 'when the section is in the student’s schedule' do
      before { create(:student_section, student: student, section: section) }

      it 'removes the section from the student’s schedule' do
        expect { student.remove_section(section) }.to change { student.sections.count }.by(-1)
        expect(student.sections).not_to include(section)
      end
    end

    context 'when the section is not in the student’s schedule' do
      it 'returns false' do
        expect(student.remove_section(section)).to be nil
        expect(student.sections).not_to include(section)
      end
    end
  end

  describe '#schedule' do
    it 'returns the student’s sections with preloaded associations' do
      create(:student_section, student: student, section: section)
      schedule = student.schedule
      expect(schedule).to include(section)
      expect(schedule.first.association(:subject)).to be_loaded
      expect(schedule.first.association(:teacher)).to be_loaded
      expect(schedule.first.association(:classroom)).to be_loaded
    end
  end

  describe '#section_conflicts?' do
    before { create(:student_section, student: student, section: section) }

    context 'when there is a time conflict' do
      let(:conflicting_section) { create(:section, start_time: Time.parse('08:30'), end_time: Time.parse('09:20'), days: %w[Monday]) }

      it 'returns true' do
        expect(student.send(:section_conflicts?, conflicting_section)).to be true
      end
    end

    context 'when there is no time conflict' do
      let(:non_conflicting_section) { create(:section, start_time: Time.parse('09:00'), end_time: Time.parse('09:50'), days: %w[Tuesday]) }

      it 'returns false' do
        expect(student.send(:section_conflicts?, non_conflicting_section)).to be false
      end
    end
  end

  describe '#overlapping_days?' do
    let(:section2) { build(:section, days: %w[Monday Tuesday]) }

    it 'returns true if days overlap' do
      expect(student.send(:overlapping_days?, section, section2)).to be true
    end

    it 'returns false if days do not overlap' do
      section2.days = %w[Tuesday Thursday]
      expect(student.send(:overlapping_days?, section, section2)).to be false
    end
  end

  describe '#overlapping_times?' do
    let(:section2) { build(:section, start_time: Time.parse('08:30'), end_time: Time.parse('09:20')) }

    it 'returns true if times overlap' do
      expect(student.send(:overlapping_times?, section, section2)).to be true
    end

    it 'returns false if times do not overlap' do
      section2.start_time = Time.parse('09:00')
      section2.end_time = Time.parse('09:50')
      expect(student.send(:overlapping_times?, section, section2)).to be false
    end
  end
end