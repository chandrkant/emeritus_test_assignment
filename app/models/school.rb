# frozen_string_literal: true

class School < ApplicationRecord
  ################## Associations ##################
  has_many :batches
  has_many :courses, through: :batches
  belongs_to :school_admin, class_name: "User", foreign_key: "user_id"

  ################## Validations ##################
  validates :name, :code, :city, :country, :user_id, presence: true
  validate :validate_unique_school_admin
  scope :school_admins, -> { joins(:school_admin).pluck(:user_id) }
  ################## Pagination ##################
  paginates_per 10

  def self.school_courses(id)
    school = School.find_by(id: id)
    school.courses.pluck(:name, :id)
  end

  def self.search(params)
    schools = self.includes(:school_admin).order(updated_at: :desc)

    if params[:name].present?
      schools = schools.where("schools.name LIKE ?", "%#{params[:name]}%")
    end

    schools = schools.where(city: params[:city]) if params[:city].present?

    if params[:country].present?
      schools = schools.where(country: params[:country])
    end

    schools.page(params[:page])
  end

  private

  def validate_unique_school_admin
    if school_admin.present? &&
         School.where(school_admin: school_admin).where.not(id: id).exists?
      errors.add(:school_admin, "can only be associated with one school")
    elsif school_admin.present? && !(school_admin.schooladmin?)
      errors.add(:school_admin, "can only assign to school admin only.")
    end
  end
end
