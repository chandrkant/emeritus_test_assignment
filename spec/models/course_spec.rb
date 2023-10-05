# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'associations' do
    it { should have_many(:batches) }
    it { should have_many(:schools).through(:batches) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:duration) }
    it { should validate_numericality_of(:duration).only_integer }
  end

  describe 'pagination' do
    it 'should have pagination limit of 10' do
      expect(Course.default_per_page).to eq(10)
    end
  end
end
