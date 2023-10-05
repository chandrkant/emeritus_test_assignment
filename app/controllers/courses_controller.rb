# frozen_string_literal: true

class CoursesController < ApplicationController
  load_and_authorize_resource
  before_action :set_course, only: %i[show edit update]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.search(params)
    respond_to do |format|
      format.html
      format.json { render :index, courses: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render :show, course: @course }
    end
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    respond_to do |format|
      if @course.save
        flash[:success] = "Course was successfully created."
        format.html { redirect_to @course }
        format.json { render json: { status: :ok, course: @course } }
      else
        flash[:error] = @course.errors.full_messages
        format.html { render :new }
        format.json do
          render json: @course.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        flash[:success] = "Course was successfully updated."
        format.html { redirect_to @course }
        format.json { render json: { status: :ok, course: @course } }
      else
        flash[:error] = @course.errors.full_messages
        format.html { render :edit }
        format.json do
          render json: @course.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def course_params
    params.require(:course).permit(:name, :duration, :code)
  end
end
