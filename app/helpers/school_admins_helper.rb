# frozen_string_literal: true

module SchoolAdminsHelper
  def find_school(user)
    School.where(user_id: user).pluck(:name, :id)
  end
end
