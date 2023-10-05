# # frozen_string_literal: true

class Student < User
  ################## Associations ##################
  # has_many :enrollments, foreign_key: "user_id"
  # has_many :enrolled_with_batch, through: :enrollments, source: :batch
  def self.classmates(user)
    batches = user.enrolled_with_batch
    User
      .includes(:enrollments)
      .where(enrollments: { batch: batches })
      .where.not(id: user.id)
      .distinct
  end
end
