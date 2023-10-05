# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_request
  protect_from_forgery unless: -> { request.format.json? }
  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  private

  ############# cancancan rescue block #############
  def handle_access_denied
    respond_to do |format|
      format.html { redirect_to root_path, alert: 'You are not authorized to access this page.' }
      format.json { render json: { error: 'Access Denied' }, status: :forbidden }
    end
  end

  ############# authentication type check #############
  def authenticate_request
    if json_request?
      authenticate_with_token!
    else
      authenticate_user!
    end
  end

  ############# brearer token authentication #############
  def authenticate_with_token!
    authenticate_user_with_token || render_unauthorized
  end

  def authenticate_user_with_token
    authenticate_with_http_token do |token, _options|
      user_id = JwtService.decode(token)['user_id']
      @current_user = User.find_by(id: user_id)
    end
  end

  def render_unauthorized
    headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def json_request?
    request.format.json? || request.content_type == 'application/json'
  end
end
