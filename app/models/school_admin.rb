# frozen_string_literal: true

class SchoolAdmin < User
  ################## Associations ##################
  has_one :school, class_name: "School", foreign_key: "user_id"
  # Ex:- scope :active, -> {where(:active => true)}
  ################## Pagination ##################
  paginates_per 10
  # scope :available_school_admins, -> { where(:attibute => value)}
  def self.available_school_admins(school_id)
    ids = School.where.not(id: school_id).school_admins
    SchoolAdmin.where.not(id: ids)
  end
end
