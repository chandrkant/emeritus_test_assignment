# frozen_string_literal: true

require "rails_helper"

RSpec.describe CoursesController, type: :controller do
  render_views
  let(:user) { create(:user) }

  before do
    sign_in(user)
    token = JwtService.encode(user_id: user.id)
    request.headers["Authorization"] = "Bearer #{token}"
  end

  describe "GET #index" do
    it "assigns @courses" do
      course1 = create(:course)
      course2 = create(:course)

      get :index

      expect(assigns(:courses)).to match_array([course1, course2])
    end

    it "renders the index template" do
      get :index

      expect(response).to render_template("index")
    end

    it "renders JSON response" do
      course1 = create(:course)
      course2 = create(:course)
      get :index, format: :json

      expected_response = [
        { "id" => course1.id, "name" => course1.name },
        { "id" => course2.id, "name" => course2.name }
      ]
      actual_response = JSON.parse(response.body)
      actual_attributes =
        actual_response.map { |course| course.slice("id", "name") }
      expect(actual_attributes.to_set).to eq(expected_response.to_set)
    end
  end

  describe "GET #show" do
    let(:course) { create(:course) }

    it "assigns the requested course" do
      get :show, params: { id: course.id }

      expect(assigns(:course)).to eq(course)
    end

    it "renders the show template" do
      get :show, params: { id: course.id }

      expect(response).to render_template("show")
    end

    it "renders JSON response" do
      get :show, params: { id: course.id }, format: :json

      expected_response = { "id" => course.id, "name" => course.name }
      expect(JSON.parse(response.body).slice("id", "name")).to eq(
        expected_response
      )
    end
  end

  describe "GET #new" do
    it "assigns a new course" do
      get :new

      expect(assigns(:course)).to be_a_new(Course)
    end

    it "renders the new template" do
      get :new

      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:valid_attributes) { attributes_for(:course) }

      it "creates a new course" do
        expect { post :create, params: { course: valid_attributes } }.to change(
          Course,
          :count
        ).by(1)
      end

      it "redirects to the created course" do
        post :create, params: { course: valid_attributes }

        expect(response).to redirect_to(Course.last)
      end

      it "sets a success flash message" do
        post :create, params: { course: valid_attributes }

        expect(flash[:success]).to be_present
      end

      it "renders JSON response" do
        post :create, params: { course: valid_attributes }, format: :json

        expect(JSON.parse(response.body)).to include("status" => "ok")
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { attributes_for(:course, name: nil) }

      it "does not create a new course" do
        expect {
          post :create, params: { course: invalid_attributes }
        }.not_to change(Course, :count)
      end

      it "renders the new template" do
        post :create, params: { course: invalid_attributes }

        expect(response).to render_template("new")
      end

      it "sets an error flash message" do
        post :create, params: { course: invalid_attributes }

        expect(flash[:error]).to be_present
      end

      it "renders JSON response with errors" do
        post :create, params: { course: invalid_attributes }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include(
          "name" => ["can't be blank"]
        )
      end
    end
  end

  describe "GET #edit" do
    let(:course) { create(:course) }

    it "assigns the requested course" do
      get :edit, params: { id: course.id }

      expect(assigns(:course)).to eq(course)
    end

    it "renders the edit template" do
      get :edit, params: { id: course.id }

      expect(response).to render_template("edit")
    end
  end

  describe "PATCH #update" do
    let(:course) { create(:course) }

    context "with valid attributes" do
      let(:valid_attributes) do
        attributes_for(:course, name: "New Course Name")
      end

      it "updates the course" do
        patch :update, params: { id: course.id, course: valid_attributes }

        course.reload
        expect(course.name).to eq("New Course Name")
      end

      it "redirects to the updated course" do
        patch :update, params: { id: course.id, course: valid_attributes }

        expect(response).to redirect_to(course)
      end

      it "sets a success flash message" do
        patch :update, params: { id: course.id, course: valid_attributes }

        expect(flash[:success]).to be_present
      end

      it "renders JSON response" do
        patch :update,
              params: {
                id: course.id,
                course: valid_attributes
              },
              format: :json

        expect(JSON.parse(response.body)).to include("status" => "ok")
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { attributes_for(:course, name: nil) }

      it "does not update the course" do
        patch :update, params: { id: course.id, course: invalid_attributes }

        course.reload
        expect(course.name).not_to be_nil
      end

      it "renders the edit template" do
        patch :update, params: { id: course.id, course: invalid_attributes }

        expect(response).to render_template("edit")
      end

      it "sets an error flash message" do
        patch :update, params: { id: course.id, course: invalid_attributes }

        expect(flash[:error]).to be_present
      end

      it "renders JSON response with errors" do
        patch :update,
              params: {
                id: course.id,
                course: invalid_attributes
              },
              format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include(
          "name" => ["can't be blank"]
        )
      end
    end
  end
end
