# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationsController, type: :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "POST #create" do
    context "with valid parameters" do
      it "registers a new user and signs in with HTML response" do
        post :create,
             params: {
               user: {
                 name: "John Doe",
                 type: "Student",
                 gender: "Male",
                 email: "john@example.com",
                 password: "password",
                 password_confirmation: "password"
               }
             }
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to eq(
          "Welcome! You have signed up successfully."
        )
        expect(controller.current_user).to be_present
      end

      it "registers a new user with JSON response" do
        post :create,
             format: :json,
             params: {
               user: {
                 name: "John Doe",
                 type: "Student",
                 gender: "Male",
                 email: "john@example.com",
                 password: "password",
                 password_confirmation: "password"
               }
             }
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("application/json")

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("token")
      end
    end

    context "with invalid parameters" do
      it "returns HTML response with errors" do
        post :create,
             params: {
               user: {
                 name: "",
                 type: "Student",
                 gender: "Male",
                 email: "john@example.com",
                 password: "password",
                 password_confirmation: "wrong_password"
               }
             }
        expect(response).to render_template(:new)
        expect(assigns(:user).errors.full_messages).to include(
          "Name can't be blank"
        )
      end

      it "returns JSON response with errors" do
        post :create,
             format: :json,
             params: {
               user: {
                 name: "",
                 type: "Teacher",
                 gender: "Male",
                 email: "john@example.com",
                 password: "password",
                 password_confirmation: "wrong_password"
               }
             }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.media_type).to eq("application/json")

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("error")
      end
    end

    context "when user type is not student" do
      it "returns HTML response with error message" do
        post :create,
             params: {
               user: {
                 name: "John Doe",
                 type: "Teacher",
                 gender: "Male",
                 email: "john@example.com",
                 password: "password",
                 password_confirmation: "password"
               }
             }
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq("Only students can sign up.")
        expect(controller.current_user).to be_nil
      end

      it "returns JSON response with error message" do
        post :create,
             format: :json,
             params: {
               user: {
                 name: "John Doe",
                 type: "Teacher",
                 gender: "Male",
                 email: "john@example.com",
                 password: "password",
                 password_confirmation: "password"
               }
             }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.media_type).to eq("application/json")

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Only students can sign up.")
      end
    end
  end
end
