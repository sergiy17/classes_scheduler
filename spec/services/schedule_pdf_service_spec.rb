require 'rails_helper'
require 'pdf-reader'

RSpec.describe SchedulePdfService, type: :service do
  let(:student) { create(:student, name: 'Kenny McCormick') }
  let(:section) do
    create(:section, start_time: Time.parse('08:00'), end_time: Time.parse('08:50'), days: %w[Monday Wednesday Friday], subject: create(:subject, name: 'Arts 154'))
  end

  describe '#generate' do
    it 'generates a PDF with the student’s schedule' do
      create(:student_section, student: student, section: section)
      pdf_data = SchedulePdfService.new(student).generate
      expect(pdf_data).to be_a(String)

      pdf = PDF::Reader.new(StringIO.new(pdf_data))
      pdf_text = pdf.pages.first.text

      expect(pdf_text).to include('Schedule for Kenny McCormick')
      expect(pdf_text).to include('Subject: Arts 154')
      expect(pdf_text).to include('Time: 08:00 AM - 08:50 AM')
      expect(pdf_text).to include('Days: Monday, Wednesday, Friday')
      expect(pdf_text).to include("Teacher: #{section.teacher.name}")
      expect(pdf_text).to include("Classroom: #{section.classroom.name}")
    end

    it 'generates an empty schedule PDF when student has no sections' do
      pdf_data = SchedulePdfService.new(student).generate
      expect(pdf_data).to be_a(String)

      pdf = PDF::Reader.new(StringIO.new(pdf_data))
      pdf_text = pdf.pages.first.text

      expect(pdf_text).to include('Schedule for Kenny McCormick')
      expect(pdf_text).not_to include('Subject:')
    end
  end
end