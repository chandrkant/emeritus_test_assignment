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
    sql = []

    sql << "users.name LIKE '%#{params[:name]}%'" if params[:name].present?
    sql << "users.email LIKE '%#{params[:email]}%'" if params[:email].present?

    # Combine conditions with 'AND'
    query = sql.join(" AND ")
    self.order("users.updated_at desc").where(query).page(params[:page])
    # You can also add additional conditions here if needed.
  end
end
