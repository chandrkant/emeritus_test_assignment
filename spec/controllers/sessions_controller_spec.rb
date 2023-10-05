# frozen_string_literal: true

require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "POST #create" do
    it "user login html response" do
      user = create(:user)
      post :create,
           params: {
             user: {
               email: user.email,
               password: "password"
             }
           }
      expect(response).to redirect_to(root_path)
    end

    it "user login #renders JSON response" do
      user = create(:user)
      post :create,
           format: :json,
           params: {
             user: {
               email: user.email,
               password: "password"
             }
           }
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("application/json")

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key("token")
      expect(json_response).to have_key("exp")
    end

    it "with invalid credential returns unauthorized" do
      post :create,
           params: {
             user: {
               email: "invalid@example.com",
               password: "invalid_password"
             }
           }
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include(
        'You are being <a href="http://test.host/users/sign_in">redirected</a>.'
      )
    end

    it "with invalid credential returns unauthorized #renders JSON response" do
      user = create(:user)
      post :create,
           format: :json,
           params: {
             user: {
               email: user.email,
               password: "invalid_password"
             }
           }
      expect(response).to have_http_status(:unauthorized)
      expect(response.media_type).to eq("application/json")

      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("Invalid email or password")
    end
  end

  describe "DELETE #destroy" do
    it "user logout html response" do
      user = create(:user)
      sign_in(user)
      delete :destroy
      expect(response.body).to include(
        'You are being <a href="http://test.host/users/sign_in">redirected</a>.'
      )
    end

    it "user logout #renders JSON response" do
      user = create(:user)
      sign_in(user)
      delete :destroy, format: :json
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("application/json")

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key("message")
    end
  end
end
