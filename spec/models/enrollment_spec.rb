# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  describe 'associations' do
    it { should belong_to(:student).class_name('User').with_foreign_key('user_id') }
    it { should belong_to(:batch) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, approved: 1, rejected: 2) }
  end

  describe 'pagination' do
    it 'should have pagination limit of 10' do
      expect(Enrollment.default_per_page).to eq(10)
    end
  end
end
