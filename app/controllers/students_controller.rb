class StudentsController < ApplicationController
  load_and_authorize_resource

  before_action :set_student, only: %i[show edit update destroy]
  # GET /students or /students.json
  def index
    @students = Student.search(params)
    respond_to do |format|
      format.html
      format.json { render :index, students: @students }
    end
  end

  # GET /students/1 or /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html do
          redirect_to student_url(@student),
                      notice: "Student was successfully created."
        end
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @student.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html do
          redirect_to student_url(@student),
                      notice: "Student was successfully updated."
        end
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @student.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy

    respond_to do |format|
      format.html do
        redirect_to students_url, notice: "Student was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def student_params
    params[:student].delete(:password) if params[:student][:password].blank?
    params.require(:student).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :gender
    )
  end
end
