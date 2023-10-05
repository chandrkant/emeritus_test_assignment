# frozen_string_literal: true

class EnrollmentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_enrollment, only: %i[show edit update show_class_mates]

  # GET /enrollments
  # GET /enrollments.json
  def index
    @enrollments = Enrollment.accessible_by(current_ability).page(params[:page])
    respond_to do |format|
      format.html
      format.json { render :index, enrollments: @enrollments }
    end
  end

  # POST /enrollments
  # POST /enrollments.json
  def create
    @enrollment = Enrollment.new(enrollment_params)
    respond_to do |format|
      if @enrollment.save
        flash[:success] = "Enrolled successfully."
        format.html { redirect_to batches_path }
        format.json { render json: { status: :ok, enrollment: @enrollment } }
      else
        flash[:error] = @enrollment.errors.full_messages
        format.html { render :new }
        format.json do
          render json: @enrollment.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /enrollments/1
  # PATCH/PUT /enrollments/1.json
  def update
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        flash[:success] = "Enrollment was successfully updated."
        format.html { redirect_to enrollments_path }
        format.json { render json: { status: :ok, enrollment: @enrollment } }
      else
        flash[:error] = @enrollment.errors.full_messages
        format.html { redirect_to enrollments_path }
        format.json do
          render json: @enrollment.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def show_class_mates
    # @enrollment_users = Student.joins(:enrollments).where(enrollments: { batch_id: @enrollment.batch_id }).pluck('users.name')
    @enrollment_users = Student.classmates(@enrollment.student)
    respond_to do |format|
      format.html
      format.json { render json: { enrollment_users: @enrollment_users } }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def enrollment_params
    params.require(:enrollment).permit(:batch_id, :user_id, :status)
  end
end
