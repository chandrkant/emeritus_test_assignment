# frozen_string_literal: true

class SchoolsController < ApplicationController
  load_and_authorize_resource
  before_action :set_school, only: %i[show edit update]

  # GET /schools
  # GET /schools.json
  def index
    @schools = School.search(params)
    respond_to do |format|
      format.html
      format.json { render :index, schools: @schools }
    end
  end

  # GET /schools/1
  # GET /schools/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render :show, school: @school }
    end
  end

  # GET /schools/new
  def new
    @school = School.new
  end

  # GET /schools/1/edit
  def edit
  end

  # POST /schools
  # POST /schools.json
  def create
    @school = School.new(school_params)
    respond_to do |format|
      if @school.save
        flash[:success] = "School was successfully created."
        format.html { redirect_to @school }
        format.json { render json: { status: :ok, school: @school } }
      else
        flash[:error] = @school.errors.full_messages
        format.html { render :new }
        format.json do
          render json: @school.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /schools/1
  # PATCH/PUT /schools/1.json
  def update
    respond_to do |format|
      if @school.update(school_params)
        flash[:success] = "School was successfully updated."
        format.html { redirect_to @school }
        format.json { render json: { status: :ok, school: @school } }
      else
        flash[:error] = @school.errors.full_messages
        format.html { render :edit }
        format.json do
          render json: @school.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_school
    @school = School.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def school_params
    params.require(:school).permit(
      :name,
      :description,
      :code,
      :street,
      :city,
      :country,
      :user_id
    )
  end
end
