# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Batch, type: :model do
  describe 'associations' do
    it { should have_many(:enrollments) }
    it { should belong_to(:course) }
    it { should belong_to(:school) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    let(:school) { create(:school) }
    let(:course) { create(:course) }
    it 'should validate start date is not greater than end date' do
      batch = Batch.new(name: Faker::Name.name, school: school, course: course, start_date: Date.today, end_date: Date.today - 1)
      expect(batch).not_to be_valid
      expect(batch.errors[:start_date]).to include('cannot be greater than end date')

      batch.end_date = Date.today + 1
      expect(batch).to be_valid
    end
  end

  describe 'pagination' do
    it 'should have pagination limit of 10' do
      expect(Batch.default_per_page).to eq(10)
    end
  end
end
