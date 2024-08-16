require 'rails_helper'
URL = "https://www.webmotors.com.br/comprar/bentley/bentayga/30-v6-tfsi-hybrid-automatico/4-portas/2021-2022/50500763?pos=p50500763g:&np=1"

RSpec.describe AttemptController, type: :controller do
  describe 'GET #run' do
    let(:attempt) { FactoryBot.build(:attempt, url: URL) }
    let(:web_scrap_service) { double('web_scrap_service') }

    before do
      allow(Attempt).to receive(:new).and_return(attempt)
      allow(WebScrapService).to receive(:new).and_return(web_scrap_service)
      allow(web_scrap_service).to receive(:run)
      allow(controller).to receive(:render)
      post :run, params: { task_id: 'task_id', url: URL }
    end

    it 'is expected to return http success' do
      expect(response).to have_http_status(:success)
    end

    it 'is expected to have created a new attempt' do
      expect(Attempt).to have_received(:new).with(task_id: 'task_id', url: URL)
    end

    it 'is expected to have called WebScrapService' do
      expect(WebScrapService).to have_received(:new).with(attempt)
    end

    it 'is expected to have ran WebScrapService' do
      expect(web_scrap_service).to have_received(:run)
    end

    it 'renders attempt' do
      expect(controller).to have_received(:render)
        .with(json: attempt.to_json, status: :ok)
    end
  end

  describe 'GET #index' do
    let!(:attempts) { double('attempts') }

    before do
      allow(Attempt).to receive(:all).and_return(attempts)
      allow(Attempt).to receive(:where).and_return(attempts)
      allow(controller).to receive(:render).and_return(nil)
    end

    describe 'when task_id is nil' do
      before do
        get :index
      end

      it 'returns all attempts' do
        expect(Attempt).to have_received(:all)
      end

      it 'renders attempts' do
        expect(controller).to have_received(:render).with(json: attempts)
      end
    end

    describe 'when task_id is not nil' do
      before do
        get :index, params: { task_id: 'task_id' }
      end

      it 'returns attempts with task_id' do
        expect(Attempt).to have_received(:where).with(task_id: 'task_id')
      end

      it 'renders attempts' do
        expect(controller).to have_received(:render).with(json: attempts)
      end
    end
  end
end
