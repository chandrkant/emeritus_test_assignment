# frozen_string_literal: true

class BatchesController < ApplicationController
  load_and_authorize_resource
  before_action :set_batch, only: %i[show edit update]

  # GET /batches
  # GET /batches.json
  def index
    @batches = Batch.accessible_by(current_ability).search(params)
    @user_enrollments =
      current_user.enrollments.pluck(:batch_id) if current_user.student?
    respond_to do |format|
      format.html
      format.json { render :index, batches: @batches }
    end
  end

  # GET /batches/1
  # GET /batches/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render :show, batch: @batch }
    end
  end

  # GET /batches/new
  def new
    @batch = Batch.new
  end

  # GET /batches/1/edit
  def edit
  end

  # POST /batches
  # POST /batches.json
  def create
    @batch = Batch.new(batch_params)
    respond_to do |format|
      if @batch.save
        flash[:success] = "Batch was successfully created."
        format.html { redirect_to @batch, status: :created }
        format.json { render json: { status: :ok, batch: @batch } }
      else
        flash[:error] = @batch.errors.full_messages
        format.html { render :new }
        format.json do
          render json: @batch.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /batches/1
  # PATCH/PUT /batches/1.json
  def update
    respond_to do |format|
      if @batch.update(batch_params)
        flash[:success] = "Batch was successfully updated."
        format.html { redirect_to @batch }
        format.json { render json: { status: :ok, batch: @batch } }
      else
        flash[:error] = @batch.errors.full_messages
        format.html { render :edit }
        format.json do
          render json: @batch.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # GET /batches/school_courses.json
  def school_courses
    courses = School.school_courses(params[:school_id])
    if courses.present?
      render json: courses.to_json, status: 200
    else
      render json: { error: "Data not found" }.to_json, status: 404
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_batch
    @batch = Batch.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def batch_params
    params.require(:batch).permit(
      :name,
      :start_date,
      :end_date,
      :school_id,
      :course_id
    )
  end
end
