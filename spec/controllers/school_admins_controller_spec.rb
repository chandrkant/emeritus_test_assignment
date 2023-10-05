# frozen_string_literal: true

require "rails_helper"

RSpec.describe SchoolAdminsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    let(:school_admin) { create(:school_admin) }

    it "returns a successful response" do
      get :show, params: { id: school_admin.id }
      expect(response).to be_successful
    end

    it "renders the show template" do
      get :show, params: { id: school_admin.id }
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        school_admin: {
          name: "John Doe",
          email: "john@example.com",
          password: "password",
          password_confirmation: "password",
          gender: "Male"
        }
      }
    end
    let(:invalid_params) do
      {
        school_admin: {
          name: "",
          email: "",
          password: "",
          password_confirmation: "",
          gender: ""
        }
      }
    end

    context "with valid params" do
      it "creates a new SchoolAdmin" do
        expect { post :create, params: valid_params }.to change(
          SchoolAdmin,
          :count
        ).by(1)
      end

      it "redirects to the created SchoolAdmin" do
        post :create, params: valid_params
        expect(response).to redirect_to(SchoolAdmin.last)
      end
    end

    context "with invalid params" do
      it "does not create a new SchoolAdmin" do
        expect { post :create, params: invalid_params }.to_not change(
          SchoolAdmin,
          :count
        )
      end

      it "renders the new template" do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    let(:school_admin) { create(:school_admin) }

    it "returns a successful response" do
      get :edit, params: { id: school_admin.id }
      expect(response).to be_successful
    end

    it "renders the edit template" do
      get :edit, params: { id: school_admin.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    let(:school_admin) { create(:school_admin) }
    let(:valid_params) do
      { school_admin: { name: "John Doe" }, id: school_admin.id }
    end
    let(:invalid_params) { { school_admin: { name: "" }, id: school_admin.id } }

    context "with valid params" do
      it "updates the SchoolAdmin" do
        patch :update, params: valid_params
        school_admin.reload
        expect(school_admin.name).to eq("John Doe")
      end

      it "redirects to the updated SchoolAdmin" do
        patch :update, params: valid_params
        expect(response).to redirect_to(school_admin)
      end
    end

    context "with invalid params" do
      it "does not update the SchoolAdmin" do
        patch :update, params: invalid_params
        school_admin.reload
        expect(school_admin.name).to_not eq("")
      end

      it "renders the edit template" do
        patch :update, params: invalid_params
        expect(response).to render_template(:edit)
      end
    end
  end
end
