require 'rails_helper'

RSpec.describe Teacher, type: :model do
  describe 'associations' do
    it 'is not allowing to destroy the teacher with sections' do
      teacher = create(:teacher)
      create(:section, teacher: teacher)

      expect(teacher.destroy).to eq(false)
    end
  end

  describe 'validations' do
    it 'requires name' do
      teacher = build(:teacher, name: nil)
      expect(teacher).not_to be_valid
      expect(teacher.errors[:name]).to include("can't be blank")
    end
  end
end
