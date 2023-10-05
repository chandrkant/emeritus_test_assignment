# frozen_string_literal: true

require "rails_helper"

RSpec.describe BatchesController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe "GET #index" do
    it "assigns batches and renders index template" do
      batches = create_list(:batch, 3)
      get :index
      expect(assigns(:batches)).to match_array(batches)
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    let(:batch) { create(:batch) }

    it "assigns the requested batch and renders show template" do
      get :show, params: { id: batch.id }
      expect(assigns(:batch)).to eq(batch)
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    it "assigns a new batch and renders new template" do
      get :new
      expect(assigns(:batch)).to be_a_new(Batch)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:course) { create(:course) }
      let(:school) { create(:school) }
      let(:valid_params) do
        attributes_for(:batch).merge(
          { course_id: course.id, school_id: school.id }
        )
      end

      it "creates a new batch" do
        expect { post :create, params: { batch: valid_params } }.to change(
          Batch,
          :count
        ).by(1)
      end

      it "redirects to the created batch" do
        post :create, params: { batch: valid_params }
        expect(response).to be_successful
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { attributes_for(:batch, name: "") }

      it "does not create a new batch" do
        expect {
          post :create, params: { batch: invalid_params }
        }.not_to change(Batch, :count)
      end

      it "renders the new template" do
        post :create, params: { batch: invalid_params }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    let(:batch) { create(:batch) }

    it "assigns the requested batch and renders edit template" do
      get :edit, params: { id: batch.id }
      expect(assigns(:batch)).to eq(batch)
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    let(:batch) { create(:batch) }

    context "with valid parameters" do
      let(:valid_params) { { name: "Updated Batch Name" } }

      it "updates the batch" do
        patch :update, params: { id: batch.id, batch: valid_params }
        batch.reload
        expect(batch.name).to eq("Updated Batch Name")
      end

      it "redirects to the updated batch" do
        patch :update, params: { id: batch.id, batch: valid_params }
        expect(response).to redirect_to(batch)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { name: "" } }

      it "does not update the batch" do
        expect {
          patch :update, params: { id: batch.id, batch: invalid_params }
        }.not_to change { batch.reload.name }
      end

      it "renders the edit template" do
        patch :update, params: { id: batch.id, batch: invalid_params }
        expect(response).to render_template(:edit)
      end
    end
  end
end
