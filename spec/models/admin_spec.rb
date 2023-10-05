# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:email) }
  end

  describe 'role' do
    let(:admin) { Admin.new }

    it 'should be an admin' do
      expect(admin.admin?).to be_truthy
    end
  end
end
