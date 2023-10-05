# frozen_string_literal: true

class Course < ApplicationRecord
  ################## Associations ##################
  has_many :batches
  has_many :schools, through: :batches

  ################## Validations ##################
  validates :name, :code, presence: true
  validates :duration, presence: true, numericality: { only_integer: true }

  ################## Pagination ##################
  paginates_per 10

  def self.search(params)
    courses = Course.all

    if params[:name].present?
      courses = courses.where("courses.name LIKE ?", "%#{params[:name]}%")
    end

    if params[:duration].present?
      courses = courses.where(duration: params[:duration])
    end

    courses.order(updated_at: :desc).page(params[:page])
  end
  def method_name
  end
end
