# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  validates :name, :type, :email, presence: true
  validates :type, inclusion: { in: %w[Admin SchoolAdmin Student].freeze }
  validates :gender, inclusion: { in: %w[Male Female], allow_nil: true }
  has_many :enrollments, foreign_key: "user_id"
  has_many :enrolled_with_batch, through: :enrollments, source: :batch
  ROLE = %w[Admin SchoolAdmin Student].freeze

  ROLE.each do |method|
    define_method "#{method.downcase}?" do
      type == method
    end
  end

  def self.search(params)
    query = self.order(updated_at: :desc)

    query = query.where("users.name LIKE ?", "%#{params[:name]}%") if params[
      :name
    ].present?
    query = query.where("users.email LIKE ?", "%#{params[:email]}%") if params[
      :email
    ].present?

    query.page(params[:page])
  end
end
