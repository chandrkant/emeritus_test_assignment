# frozen_string_literal: true

class Batch < ApplicationRecord
  ################## Associations ##################
  has_many :enrollments
  belongs_to :course
  belongs_to :school

  ################## Validations ##################
  validates :name, :start_date, :end_date, presence: true
  validate :start_date_cannot_be_greater_than_end_date

  ################## Pagination ##################
  paginates_per 10

  def self.search(params)
    sql = []

    sql << "batches.name LIKE '%#{params[:name]}%'" if params[:name].present?

    sql.join(" AND ")
    self
      .includes(:school, :course)
      .order("batches.updated_at desc")
      .where(sql)
      .page(params[:page])
  end

  private

  def start_date_cannot_be_greater_than_end_date
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:start_date, "cannot be greater than end date")
    end
  end
end
