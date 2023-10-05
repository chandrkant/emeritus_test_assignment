# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:email) }
    it { should validate_inclusion_of(:type).in_array(User::ROLE) }
  end

  describe 'methods' do
    let(:user) { User.new }

    User::ROLE.each do |role|
      describe "##{role.downcase}?" do
        it "returns true if user's type is #{role}" do
          user.type = role
          expect(user.send("#{role.downcase}?")).to be true
        end

        it "returns false if user's type is not #{role}" do
          user.type = 'InvalidRole'
          expect(user.send("#{role.downcase}?")).to be false
        end
      end
    end
  end
end
