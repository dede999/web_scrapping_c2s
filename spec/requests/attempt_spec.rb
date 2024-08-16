require 'rails_helper'
URL = "https://www.webmotors.com.br/comprar/bentley/bentayga/30-v6-tfsi-hybrid-automatico/4-portas/2021-2022/50500763?pos=p50500763g:&np=1"

RSpec.describe "Attempts", type: :request do
  describe "POST /run" do
    let(:task_id) { "task_id" }
    let(:expected_brand) { URL.split("/")[4] }
    let(:expected_model) { URL.split("/")[5] }

    before do
      post "/run", params: { task_id: "task_id", url: URL }
    end

    after do
      Attempt.destroy_all
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "is expected to have a new attempt in the response" do
      expect(JSON.parse(response.body)["task_id"]).to eq("task_id")
      expect(JSON.parse(response.body)["url"]).to eq(URL)
      expect(JSON.parse(response.body)["brand"]).to eq(expected_brand)
      expect(JSON.parse(response.body)["model"]).to eq(expected_model)
    end
  end

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
