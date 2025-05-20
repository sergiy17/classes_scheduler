require 'rails_helper'

RSpec.describe Classroom, type: :model do
  describe 'associations' do
    it 'has many sections that raise an error when classroom is destroyed' do
      classroom = create(:classroom)
      create(:section, classroom: classroom)
      expect(classroom.destroy).to eq(false)
    end
  end

  describe 'validations' do
    it 'requires name' do
      classroom = build(:classroom, name: nil)
      expect(classroom).not_to be_valid
      expect(classroom.errors[:name]).to include("can't be blank")
    end

    it 'requires unique name' do
      create(:classroom, name: 'Room 101')
      classroom = build(:classroom, name: 'Room 101')
      expect(classroom).not_to be_valid
      expect(classroom.errors[:name]).to include('has already been taken')
    end
  end
end