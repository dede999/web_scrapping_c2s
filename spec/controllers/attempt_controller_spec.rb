require 'rails_helper'

RSpec.describe AttemptController, type: :controller do
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
