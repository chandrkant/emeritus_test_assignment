# frozen_string_literal: true

class SchoolAdminsController < ApplicationController
  load_and_authorize_resource
  before_action :set_school_admin, only: %i[show edit update]

  # GET /school_admins
  # GET /school_admins.json
  def index
    @school_admins = SchoolAdmin.search(params)
    respond_to do |format|
      format.html
      format.json { render :index, school_admins: @school_admins }
    end
  end

  # GET /school_admins/1
  # GET /school_admins/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render :show, school_admin: @school_admin }
    end
  end

  # GET /school_admins/new
  def new
    @school_admin = SchoolAdmin.new
  end

  # GET /school_admins/1/edit
  def edit
  end

  # POST /school_admins
  # POST /school_admins.json
  def create
    @school_admin = SchoolAdmin.new(school_admin_params)
    respond_to do |format|
      if @school_admin.save
        flash[:success] = "SchoolAdmin was successfully created."
        format.html { redirect_to @school_admin }
        format.json do
          render json: { status: :ok, school_admin: @school_admin }
        end
      else
        flash[:error] = @school_admin.errors.full_messages
        format.html { render :new }
        format.json do
          render json: @school_admin.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /school_admins/1
  # PATCH/PUT /school_admins/1.json
  def update
    respond_to do |format|
      if @school_admin.update(school_admin_params)
        flash[:success] = "School admin was successfully updated."
        format.html { redirect_to @school_admin }
        format.json do
          render json: { status: :ok, school_admin: @school_admin }
        end
      else
        flash[:error] = @school_admin.errors.full_messages
        format.html { render :edit }
        format.json do
          render json: @school_admin.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_school_admin
    @school_admin = SchoolAdmin.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def school_admin_params
    if params[:school_admin][:password].blank?
      params[:school_admin].delete(:password)
    end
    params.require(:school_admin).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :gender
    )
  end
end
