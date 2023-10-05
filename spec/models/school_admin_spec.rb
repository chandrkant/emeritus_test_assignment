# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SchoolAdmin, type: :model do
  describe 'associations' do
    it { should have_one(:school).class_name('School').with_foreign_key('user_id') }
  end

  describe 'pagination' do
    it 'should have pagination limit of 10' do
      expect(SchoolAdmin.default_per_page).to eq(10)
    end
  end
end
