# frozen_string_literal: true

require "rails_helper"

RSpec.describe SchoolsController, type: :controller do
  render_views
  let(:user) { create(:user) }

  before do
    sign_in(user)
    token = JwtService.encode(user_id: user.id)
    request.headers["Authorization"] = "Bearer #{token}"
  end

  let(:valid_attributes) do
    {
      name: "Example School",
      description: "A great school",
      code: "SCH001",
      street: "123 Example Street",
      city: "Example City",
      country: "Example Country",
      user_id: 1,
      batch_ids: [1, 2, 3],
      course_ids: [1, 2, 3]
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      description: "A great school",
      code: "SCH001",
      street: "123 Example Street",
      city: "Example City",
      country: "Example Country",
      user_id: 1,
      batch_ids: [4, 5, 6],
      course_ids: [1, 2, 3]
    }
  end

  describe "GET #index" do
    let(:schools) { create_list(:school, 3) }
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "returns JSON response with schools" do
      get :index, format: :json
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    let(:school) { create(:school) }

    it "assigns the requested school to @school" do
      get :show, params: { id: school.id }
      expect(assigns(:school)).to eq(school)
    end

    it "renders the show template" do
      get :show, params: { id: school.id }
      expect(response).to render_template(:show)
    end

    it "returns JSON response with school" do
      get :show, params: { id: school.id }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #new" do
    it "assigns a new school to @school" do
      get :new
      expect(assigns(:school)).to be_a_new(School)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    let(:school) { create(:school) }

    it "assigns the requested school to @school" do
      get :edit, params: { id: school.id }
      expect(assigns(:school)).to eq(school)
    end

    it "renders the edit template" do
      get :edit, params: { id: school.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:school_admin) { create(:school_admin) }
      let(:school_params) do
        attributes_for(:school).merge(user_id: school_admin.id)
      end

      it "creates a new school" do
        expect { post :create, params: { school: school_params } }.to change(
          School,
          :count
        ).by(1)
      end

      it "redirects to the created school" do
        post :create, params: { school: school_params }
        expect(response).to redirect_to(School.last)
      end

      it "returns JSON response with school" do
        post :create, params: { school: school_params }, format: :json
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["school"]).to be_present
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { attributes_for(:school, name: nil) }

      it "does not create a new school" do
        expect {
          post :create, params: { school: invalid_params }
        }.not_to change(School, :count)
      end

      it "renders the new template" do
        post :create, params: { school: invalid_params }
        expect(response).to render_template(:new)
      end

      it "returns JSON response with errors" do
        post :create, params: { school: invalid_params }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        # json_response = JSON.parse(response.body)
        # expect(json_response['errors']).to be_present
      end
    end
  end

  describe "PATCH #update" do
    let(:school) { create(:school) }

    context "with valid parameters" do
      let(:updated_name) { "Updated School" }
      let(:updated_params) { { name: updated_name } }

      it "updates the school" do
        patch :update, params: { id: school.id, school: updated_params }
        school.reload
        expect(school.name).to eq(updated_name)
      end

      it "redirects to the updated school" do
        patch :update, params: { id: school.id, school: updated_params }
        expect(response).to redirect_to(school)
      end

      it "returns JSON response with school" do
        patch :update,
              params: {
                id: school.id,
                school: updated_params
              },
              format: :json
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["school"]).to be_present
        expect(json_response["school"]["name"]).to eq(updated_name)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { name: nil } }

      it "does not update the school" do
        patch :update, params: { id: school.id, school: invalid_params }
        school.reload
        expect(school.name).not_to be_nil
      end

      it "renders the edit template" do
        patch :update, params: { id: school.id, school: invalid_params }
        expect(response).to render_template(:edit)
      end

      it "returns JSON response with errors" do
        patch :update,
              params: {
                id: school.id,
                school: invalid_params
              },
              format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
