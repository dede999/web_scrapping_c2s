require 'rails_helper'

RSpec.describe Attempt, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:task_id) }

    describe 'when attemp is successful' do
      let(:attempt) { Attempt.new success: true }
      let(:valid_attempt) { FactoryBot.build(:attempt, success: true) }

      it 'is expected to be valid' do
        expect(valid_attempt).to be_valid
      end

      %i[brand model price].each do |field|
        it "is invalid without #{field}" do
          attempt.valid?
          expect(attempt.errors.messages).to have_key(field)
        end
      end
    end

    describe 'when attempt is not successful' do
      let(:attempt) { Attempt.new success: false, task_id: '1' }

      it 'is expected to be valid' do
        expect(attempt).to be_valid
      end
    end
  end
end
