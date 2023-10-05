# frozen_string_literal: true

RSpec.describe Student, type: :model do
  describe 'inheritance' do
    it { should be_a(User) }
  end
end
