require 'rails_helper'

RSpec.describe Subject, type: :model do
  describe 'associations' do
    it 'is not allowing to destroy the subject with sections' do
      subject = create(:subject)
      create(:section, subject: subject)
      expect(subject.destroy).to eq(false)
    end
  end

  describe 'validations' do
    it 'requires name' do
      subject = build(:subject, name: nil)
      expect(subject).not_to be_valid
      expect(subject.errors[:name]).to include("can't be blank")
    end

    it 'requires unique name' do
      create(:subject, name: 'Math')
      subject = build(:subject, name: 'Math')
      expect(subject).not_to be_valid
      expect(subject.errors[:name]).to include('has already been taken')
    end
  end
end