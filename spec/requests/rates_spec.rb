require 'rails_helper'

RSpec.describe 'Rates', type: :request do
  describe 'GET api/v1/rates/:date' do
    let(:date) { '2020-03-02' }
    let(:expected_body) do
      {
        "success": true,
        "timestamp": 1_581_811_199,
        "historical": true,
        "base": 'EUR',
        "date": date,
        "rates": {
          "USD": 1.083085
        }
      }
    end

    describe 'success response' do
      subject do
        get "/api/v1/rates/#{date}", params: { base: 'EUR', other: 'USD' }
        response
      end

      before do
        stub_request(:get, /.*fixer.*/)
          .to_return(status: 200, body: expected_body.to_json, headers: {})
      end

      it { is_expected.to have_http_status(:success) }

      it do
        expect { subject }.to change(Rate, :count).by(1)
      end
    end

    describe 'success response' do
      let(:date) { 'invalid_date' }

      subject do
        get "/api/v1/rates/#{date}", params: { base: 'EUR', other: 'USD' }
        response
      end

      before do
        stub_request(:get, /.*fixer.*/)
          .to_return(status: 200, body: expected_body.to_json, headers: {})
      end

      it { is_expected.to have_http_status(500) }
    end
  end
end
