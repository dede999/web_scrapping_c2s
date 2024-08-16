require 'rails_helper'
URL = "https://www.webmotors.com.br/comprar/bentley/bentayga/30-v6-tfsi-hybrid-automatico/4-portas/2021-2022/50500763?pos=p50500763g:&np=1"

RSpec.describe WebScrapService, type: :service do
  describe '#initialize' do
    let(:attempt) { FactoryBot.build(:attempt, url: URL) }
    let(:service) { WebScrapService.new(attempt) }

    it 'is expected to set attempt' do
      expect(service.attempt).to eq(attempt)
    end

    it 'is expected to set doc' do
      expect(service.doc).to be_a(Nokogiri::HTML::Document)
    end

    it 'is expected to set success to false' do
      expect(attempt.success).to eq(false)
    end
  end

  describe '#get_page_content' do
    let(:attempt) { FactoryBot.build(:attempt, url: URL) }
    let(:service) { WebScrapService.new(attempt) }
    let(:response) { double(Faraday::Response) }
    let(:response_body) { '<html></html>' }

    before do
      allow(Faraday).to receive(:get).and_return(response)
      allow(response).to receive(:body).and_return(response_body)
    end

    describe 'when parse works fine' do
      let(:doc) { double(Nokogiri::HTML::Document) }

      before do
        allow(Nokogiri::HTML).to receive(:parse).and_return(doc)
        service.get_page_content
      end

      it 'is expected to call Nokogiri::HTML.parse' do
        expect(Nokogiri::HTML).to have_received(:parse).with(response_body).at_least(:once)
      end

      it 'is expected to set doc' do
        expect(service.doc).to eq(doc)
      end

      it 'is expected to have called the api' do
        expect(Faraday).to have_received(:get).with(attempt.url).at_least(:once)
      end
    end

    describe 'when parse fails' do
      before do
        allow(Nokogiri::HTML).to receive(:parse).and_raise
      end

      it 'is expected to return nil when an error is risen' do
        expect(service.get_page_content).to eq(nil)
      end
    end
  end

  describe '#set_brand_and_model' do
    let(:attempt) { FactoryBot.build(:attempt, url: URL) }
    let(:service) { WebScrapService.new(attempt) }
    let(:expected_brand) { URL.split('/')[4] }
    let(:expected_model) { URL.split('/')[5] }

    before do
      service.set_brand_and_model
    end

    it 'is expected to set brand' do
      expect(attempt.brand).to eq(expected_brand)
    end

    it 'is expected to set model' do
      expect(attempt.model).to eq(expected_model)
    end
  end

  describe '#parse_price' do
    let(:attempt) { FactoryBot.build(:attempt, url: URL) }
    let(:service) { WebScrapService.new(attempt) }
    let(:doc) { double(Nokogiri::HTML::Document) }

    describe 'when price is found' do
      let(:price) { double('Nokogiri::HTML::Node') }

      before do
        service.doc = doc
        allow(price).to receive(:text).and_return('R$ 100.000,00')
        allow(doc).to receive(:css).and_return(price)
        service.parse_price
      end

      it 'is expected to set success to true' do
        expect(attempt.success).to eq(true)
      end

      it 'is expected to set price' do
        expect(attempt.price).to eq(100_000.00)
      end
    end

    describe 'when price is not found' do
      before do
        allow(doc).to receive(:css).and_return([])
        service.parse_price
      end

      it 'is expected to set success to false' do
        expect(attempt.success).to eq(false)
      end
    end

    describe 'when doc is nil' do
      before do
        allow(doc).to receive(:nil?).and_return(true)
        allow(doc).to receive(:css)
        service.parse_price
      end

      it 'is expected doc to not have checked the price' do
        expect(doc).not_to have_received(:css)
      end
    end
  end

  describe '#run' do
    let(:attempt) { FactoryBot.build(:attempt, url: URL) }
    let(:service) { WebScrapService.new(attempt) }

    before do
      allow(service).to receive(:set_brand_and_model)
      allow(service).to receive(:parse_price)
      service.run
    end

    it 'is expected to have saved the attempt' do
      expect(attempt).to be_persisted
    end

    it 'is expected to call set_brand_and_model' do
      expect(service).to have_received(:set_brand_and_model).at_least(:once)
    end

    it 'is expected to call parse_price' do
      expect(service).to have_received(:parse_price).at_least(:once)
    end
  end
end
