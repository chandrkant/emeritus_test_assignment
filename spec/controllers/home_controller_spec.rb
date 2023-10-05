# frozen_string_literal: true

require "rails_helper"

RSpec.describe HomeController, type: :controller do
  render_views

  let(:user) { create(:user) }
  before { sign_in(user) }
  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "returns a 200 OK status" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
