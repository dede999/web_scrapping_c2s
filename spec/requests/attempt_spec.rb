require 'rails_helper'

RSpec.describe "Attempts", type: :request do
  describe "GET /index" do
    let!(:attempt) { FactoryBot.create_list(:attempt, 2) }
    let!(:other_attempt) { FactoryBot.create(:attempt, task_id: "other") }

    after do
      Attempt.destroy_all
    end

    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end

    it "returns all attempts" do
      get "/"
      expect(JSON.parse(response.body).size).to eq(3)
    end

    it "returns only attempts with task_id" do
      get "/attempts/other"
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

end
