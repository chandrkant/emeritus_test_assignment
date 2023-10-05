# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_request, only: %i[create], if: :json_request?
  before_action :configure_sign_up_params, only: %i[create]
  before_action :authorize_student_signup, only: %i[create]

  def create
    build_resource(sign_up_params)
    if resource.save
      sign_in(resource)
      flash[:success] = 'Welcome! You have signed up successfully.'
      respond_with resource do |format|
        format.html { redirect_to after_sign_up_path_for(resource) }
        format.json { render json: { token: JwtService.encode({ user_id: resource.id }) } }
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def authorize_student_signup
    unless params[:user][:type] == 'Student'
      if json_request?
        render json: { error: 'Only students can sign up.' }, status: :unprocessable_entity
      else
        flash[:error] = 'Only students can sign up.'
        redirect_to root_path
      end
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name type gender email password password_confirmation])
  end
end
