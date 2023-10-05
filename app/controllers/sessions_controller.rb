# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_request, only: %i[create], if: :json_request?

  def create
    user = User.find_by(email: params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      if json_request?
        # Handle JWT authentication for JSON requests
        time = Time.now + 24.hours.to_i
        render json: {
          token: JwtService.encode(user_id: user.id),
          exp: time.strftime('%m-%d-%Y %H:%M')
        }, status: :ok
      else
        # Handle session-based authentication for HTML requests
        super
      end
    else
      # Authentication failed
      flash[:error] = 'Invalid email or password'
      respond_to do |format|
        format.html { redirect_to new_user_session_path, status: :unauthorized }
        format.json { render json: { error: 'Invalid email or password' }, status: :unauthorized }
      end
    end
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out

    respond_to do |format|
      format.html { redirect_to new_user_session_path }
      format.json { render json: { message: 'Logged out successfully' } }
    end
  end
end
