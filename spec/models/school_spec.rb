# frozen_string_literal: true

require 'rails_helper'

RSpec.describe School, type: :model do
  describe 'associations' do
    it { should have_many(:batches) }
    it { should have_many(:courses).through(:batches) }
    it { should belong_to(:school_admin).class_name('User').with_foreign_key('user_id') }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'custom validations' do
    let(:school_admin) { FactoryBot.create(:user, type: 'SchoolAdmin') }
    let(:school) { FactoryBot.create(:school, school_admin: school_admin) }

    it 'validates unique school admin association' do
      expect(school).to be_valid

      duplicate_school = build(:school, school_admin: school_admin)
      expect(duplicate_school).not_to be_valid
      expect(duplicate_school.errors[:school_admin]).to include('can only be associated with one school')
    end

    it 'validates school admin role' do
      school_admin = create(:user)
      school.school_admin = school_admin

      expect(school).not_to be_valid
      expect(school.errors[:school_admin]).to include('can only assign to school admin only.')
    end
  end
end
