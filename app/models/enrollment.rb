# frozen_string_literal: true

class Enrollment < ApplicationRecord
  ################## Associations ##################
  belongs_to :student, class_name: 'User', foreign_key: 'user_id'
  belongs_to :batch

  enum status: { pending: 0, approved: 1, rejected: 2 }

  ################## Pagination ##################
  paginates_per 10
end
