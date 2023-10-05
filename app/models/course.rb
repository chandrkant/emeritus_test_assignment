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
    sql = []

    sql << "courses.name LIKE '%#{params[:name]}%'" if params[:name].present?
    if params[:duration].present?
      sql << "courses.duration = '#{params[:duration]}'"
    end

    query = sql.join(" AND ")

    query.present? ? query : nil
    order("courses.updated_at desc").where(query).page(params[:page])
  end
  def method_name
  end
end
