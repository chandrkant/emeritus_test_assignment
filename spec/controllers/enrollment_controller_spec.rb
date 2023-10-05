# frozen_string_literal: true

require "rails_helper"

RSpec.describe EnrollmentsController, type: :controller do
  render_views

  let(:user) { create(:user) }

  before do
    sign_in(user)
    token = JwtService.encode(user_id: user.id)
    request.headers["Authorization"] = "Bearer #{token}"
  end

  describe "GET #index" do
    let!(:enrollments) { create_list(:enrollment, 3) }

    it "assigns all enrollments to @enrollments" do
      get :index
      expect(assigns(:enrollments)).to match_array(enrollments)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "returns JSON response with enrollments" do
      get :index, format: :json
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.count).to eq(3)
    end
  end

  describe "POST #create" do
    let(:batch) { create(:batch) }
    let(:user) { create(:user) }
    let(:enrollment_params) { { batch_id: batch.id, user_id: user.id } }

    context "with valid parameters" do
      it "creates a new enrollment" do
        expect {
          post :create, params: { enrollment: enrollment_params }
        }.to change(Enrollment, :count).by(1)
      end

      it "redirects to batches path" do
        post :create, params: { enrollment: enrollment_params }
        expect(response).to redirect_to(batches_path)
      end

      it "returns JSON response with enrollment" do
        post :create, params: { enrollment: enrollment_params }, format: :json
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["enrollment"]).to be_present
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { batch_id: nil, user_id: nil } }

      it "does not create a new enrollment" do
        expect {
          post :create, params: { enrollment: invalid_params }
        }.not_to change(Enrollment, :count)
      end

      it "renders the new template" do
        post :create, params: { enrollment: invalid_params }
        expect(response).to render_template(:new)
      end

      it "returns JSON response with errors" do
        post :create, params: { enrollment: invalid_params }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    let(:enrollment) { create(:enrollment) }
    let(:updated_status) { "approved" }
    let(:updated_params) { { status: updated_status } }

    context "with valid parameters" do
      it "updates the enrollment" do
        patch :update, params: { id: enrollment.id, enrollment: updated_params }
        enrollment.reload
        expect(enrollment.status).to eq(updated_status)
      end

      it "redirects to enrollments path" do
        patch :update, params: { id: enrollment.id, enrollment: updated_params }
        expect(response).to redirect_to(enrollments_path)
      end

      it "returns JSON response with updated enrollment" do
        patch :update,
              params: {
                id: enrollment.id,
                enrollment: updated_params
              },
              format: :json
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["enrollment"]).to be_present
        expect(json_response["enrollment"]["status"]).to eq(updated_status)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { status: "rejected" } }

      it "does not update the enrollment" do
        patch :update, params: { id: enrollment.id, enrollment: invalid_params }
        enrollment.reload
        expect(enrollment.status).not_to be_nil
      end

      it "redirects to enrollments path" do
        patch :update, params: { id: enrollment.id, enrollment: invalid_params }
        expect(response).to redirect_to(enrollments_path)
      end

      it "returns JSON response with errors" do
        patch :update,
              params: {
                id: enrollment.id,
                enrollment: invalid_params
              },
              format: :json
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["enrollment"]["status"]).to eq("rejected")
      end
    end
  end

  describe "GET #show_class_mates" do
    let(:batch) { create(:batch) }
    let(:enrollment) { create(:enrollment, batch: batch) }
    let!(:class_mates) { create_list(:student, 3, enrollments: [enrollment]) }

    it "renders the show_class_mates template" do
      get :show_class_mates, params: { id: enrollment.id }
      expect(response).to render_template(:show_class_mates)
    end

    it "returns JSON response with enrollment users" do
      get :show_class_mates, params: { id: enrollment.id }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
