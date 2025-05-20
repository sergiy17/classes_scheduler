require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  let(:student) { create(:student) }
  let(:section) { create(:section) }

  describe 'GET #show' do
    context 'when student exists' do
      it 'returns the student with associated sections' do
        create(:student_section, student: student, section: section)
        get :show, params: { id: student.id }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['id']).to eq(student.id)
        expect(json['sections'].first['id']).to eq(section.id)
      end

      it 'returns the student with associated sections in serialized format' do
        create(:student_section, student: student, section: section)
        get :show, params: { id: student.id }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['id']).to eq(student.id)
        expect(json['name']).to eq(student.name)

        expect(json['sections'].first['id']).to eq(section.id)
        expect(json['sections'].first['subject']['name']).to eq(section.subject.name)
        expect(json['sections'].first['teacher']['name']).to eq(section.teacher.name)
        expect(json['sections'].first['classroom']['name']).to eq(section.classroom.name)
      end
    end

    context 'when student does not exist' do
      it 'returns a not found error' do
        get :show, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Not found')
      end
    end
  end

  describe 'POST #add_section' do
    context 'when section can be added' do
      it 'adds the section and returns success' do
        expect {
          post :add_section, params: { id: student.id, section_id: section.id }
        }.to change { student.sections.count }.by(1)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Section added successfully')
      end
    end

    context 'when section causes a time conflict' do
      it 'returns an error' do
        conflicting_section = create(:section, start_time: section.start_time, end_time: section.end_time, days: section.days)
        create(:student_section, student: student, section: section)
        post :add_section, params: { id: student.id, section_id: conflicting_section.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Cannot add section')
      end
    end

    context 'when section does not exist' do
      it 'returns a not found error' do
        post :add_section, params: { id: student.id, section_id: 999 }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Cannot add section')
      end
    end
  end

  describe 'DELETE #remove_section' do
    context 'when section is in student’s schedule' do
      it 'removes the section and returns success' do
        create(:student_section, student: student, section: section)
        expect {
          delete :remove_section, params: { id: student.id, section_id: section.id }
        }.to change { student.sections.count }.by(-1)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Section removed successfully')
      end
    end

    context 'when section is not in student’s schedule' do
      it 'returns an error' do
        delete :remove_section, params: { id: student.id, section_id: section.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq("Cannot remove selection")
      end
    end
  end

  describe 'GET #schedule_pdf' do
    context 'when student exists' do
      it 'returns a PDF with the student’s schedule' do
        create(:student_section, student: student, section: section)
        get :schedule_pdf, params: { id: student.id }
        expect(response).to have_http_status(:ok)
        expect(response.header['Content-Type']).to eq('application/pdf')
      end
    end

    context 'when student does not exist' do
      it 'returns a not found error' do
        get :schedule_pdf, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Student not found')
      end
    end
  end
end